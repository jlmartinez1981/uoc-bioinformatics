import * as express from 'express';
// import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as logger from 'morgan';
import * as path from 'path';
import * as errorHandler from 'errorhandler';
import * as methodOverride from 'method-override';
import * as compression from 'compression'; // compresses requests
import * as fs from 'fs';
import * as fileUpload from 'express-fileupload';
import * as dateFormat from 'dateformat';
import { SnpUtils } from '../utils/snp.utils';
import { FileService } from '../repository/file.service';
import { ReportService } from '../report/report.service';
import { ETLService } from '../data-transform/etl.service';

/**
 * The server.
 *
 * @class Server
 */
export class Server {

  public app: express.Application;
  private fileService: FileService;
  private reportService: ReportService;
  private etlService: ETLService;

  /**
   * Bootstrap the application.
   *
   * @class Server
   * @method bootstrap
   * @static
   * @return
   */
  public static bootstrap(): Server {
    return new Server();
  }

  /**
   * Constructor.
   *
   * @class Server
   * @constructor
   */
  constructor() {

    this.initServices();
    // create expressjs application
    this.app = express();

    // configure application
    this.config();

    // add routes
    this.routes();

    // add api
    this.api();
  }

  private initServices(): void {
    this.fileService = FileService.getInstance();
    this.reportService = ReportService.getInstance();
    this.etlService = ETLService.getInstance();
  }

  /**
   * Create REST API routes
   *
   * @class Server
   * @method api
   */
  public api() {
    // empty for now
  }

  /**
   * Configure application
   *
   * @class Server
   * @method config
   */
  public config() {
    this.app.set('port', process.env.PORT || 3000);
    this.app.set('views', path.join(__dirname, '../../views'));
    this.app.set('view engine', 'ejs');
    // this.app.use(compression());
    this.app.use(fileUpload());

    // this.app.use(bodyParser.json());
    // this.app.use(bodyParser.urlencoded({ extended: true }));
    /**
     * Error Handler. Provides full stack - remove for production
     */
    this.app.use(errorHandler());

    /**
     * https://coligo.io/building-ajax-file-uploader-with-node/
     * https://gist.github.com/paambaati/db2df71d80f20c10857d
     */

    const listeningPort = this.app.get('port');
    this.app.listen(listeningPort, function() {
      console.log('Reports Server up: http://localhost:', listeningPort);
    });
  }

  /**
   * Create router
   *
   * @class Server
   * @method api
   */
  public routes() {
    // reference to this for using it in callback functions
    const that = this;
    // static  files mapped to a virtual directory
    this.app.use('/static', express.static(path.join(__dirname, '../../public')));

    // index
    this.app.get('/', function(req: express.Request, res: express.Response) {
      res.render('pages/index');
    });

    // ejs test https://scotch.io/tutorials/use-ejs-to-template-your-node-application
    this.app.get('/reports', function(req: express.Request, res: express.Response) {
      const reportsPath = FileService.REPORTS_PATH;
      const files = that.fileService.listFiles(reportsPath);
      res.render('pages/reports', {reportfiles: files});
    });

    // upload
    /*
    Your input's name field is foo: <input name="foo" type="file" />
    The req.files.foo object will contain the following:

    req.files.foo.name: "car.jpg"
    req.files.foo.mv: A function to move the file elsewhere on your server
    req.files.foo.mimetype: The mimetype of your file
    req.files.foo.data: A buffer representation of your file
    req.files.foo.truncated: A boolean that represents if the file is over the size limit
    */
    // upload
    this.app.post('/upload', async function(req, res, next) {
      console.log('UPLOADING FILE...');
      try {
        const uploadsPath = FileService.UPLOAD_PATH;
        const dateStr: string = dateFormat(Date.now(), 'yyyymmddHHMMss');
        if (Object.keys(req.files).length === 0 && req.files.constructor === Object) {
          // the rest of parameters come in req.body
          const params: any = req.body;
          if (SnpUtils.checkSNPText(params.snpText)) {
            // TODO save the file with title|anomymous-date.txt
            const snpFileName: string = (params.fileName !== '' ? params.fileName : 'anonymous');
            const storageName = dateStr.concat('-', snpFileName);
            console.log('SnpFileName: ', storageName);
          }
          // TODO create file and save it
          const result = true;

          if (result == true) {
            res.render('pages/results', {uploadResult: 'SNP text uploaded!'});
          }
        } else {
          // Save file if it exists
          // The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
          const snpFile: any = req.files ? req.files.snpFile : undefined;
          if (!snpFile) {
            throw 'Upload file: No file provided!';
          }
          const fileName = dateStr.concat('-', snpFile.name);
          const filePath = path.join(uploadsPath, fileName);
          // Use the mv() method to place the file somewhere on your server
          const fileUploadPromise = snpFile.mv(filePath); /*, function(err: any) {
            if (err) {
              console.error(`Error copying file to ${filePath}: ${err}`);
              return res.status(500).send(err);
            }
            res.render('pages/results', {uploadResult: `${fileName} SNP file uploaded!`});
            });*/
            fileUploadPromise.then((result: any) => {
              console.log(`${fileName} file uploaded to ${filePath}`);
              console.log(`Starting ETL process for file ${fileName}`);

              const transformedPromise = that.etlService.transform(filePath, fileName);
              transformedPromise.then((result: any) => {
                console.log(`${filePath} transformed to ${result}`);
                console.log(`Starting report generation for file ${fileName}`);
                // TODO generate report
                const reportPromise = that.reportService.generateReport(result, fileName);
                reportPromise.then((result: any) => {
                  console.log(`${filePath} report generated for file ${result}`);
                  }).catch((err: any) => {
                    console.error(`Error transforming file ${filePath}: ${err}`);
                  });

                }).catch((err: any) => {
                  console.error(`Error transforming file ${filePath}: ${err}`);
                });

              res.render('pages/results', {uploadResult: `${fileName} SNP file uploaded!`});
            }).catch((err: any) => {
              console.error(`Error copying file to ${filePath}: ${err}`);
              return res.render('pages/error', {error: err});
            });
          }
      } catch (err) {
        console.error(`Error uploading file: ${err}`);
        // return res.status(500).send(err);
        return res.render('pages/error', {error: err});
      }
    });
  }
}