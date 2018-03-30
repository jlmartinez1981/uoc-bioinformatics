import * as express from 'express';
// import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as logger from 'morgan';
import * as path from 'path';
import * as errorHandler from 'errorhandler';
import * as methodOverride from 'method-override';
import * as compression from 'compression'; // compresses requests
// import * as formidable from 'formidable';
import * as fs from 'fs';
import * as fileUpload from 'express-fileupload';
import * as dateFormat from 'dateformat';
import { SnpUtils } from '../utils/snp.utils';
import { FileService } from '../repository/file.service';
import { ReportService } from '../report/report.service';

/**
 * The server.
 *
 * @class Server
 */
export class Server {

  public app: express.Application;
  private fileService: FileService;
  private reportService: ReportService;

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
    // static  files mapped to a virtual directory
    this.app.use('/static', express.static(path.join(__dirname, '../../public')));

    // index
    this.app.get('/', function(req: express.Request, res: express.Response) {
      res.render('pages/index');
    });

    // ejs test https://scotch.io/tutorials/use-ejs-to-template-your-node-application
    this.app.get('/test', function(req: express.Request, res: express.Response) {
      // res.render(path.join(__dirname + '../../../views/test'));
      res.render('pages/test', {greeting: 'Hello world!'});
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
        const uploadsPath = path.join(__dirname, '../../uploads');
        // create dir if does not exist
        if (!fs.existsSync(uploadsPath)) {
          fs.mkdirSync(uploadsPath);
        }

        if (Object.keys(req.files).length === 0 && req.files.constructor === Object) {
          // the rest of parameters come in req.body
          const params: any = req.body;
          if (SnpUtils.checkSNPText(params.snpText)) {
            // TODO save the file with title|anomymous-date.txt
            const snpFileName: string = (params.fileName !== '' ? params.fileName : 'anonymous');
            const dateStr = dateFormat(Date.now(), 'yyyymmddHHMMss');
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
          const fileName = snpFile.name;
          const filePath = path.join(uploadsPath, fileName);
          // Use the mv() method to place the file somewhere on your server
          snpFile.mv(filePath, function(err: any) {
            if (err) {
              console.error(`Error copying file to ${filePath}: ${err}`);
              return res.status(500).send(err);
            }
            res.render('pages/results', {uploadResult: 'SNP file uploaded!'});
            });
          }
      } catch (err) {
        console.error(`Error uploading file: ${err}`);
        // return res.status(500).send(err);
        return res.render('pags/error', {error: err});
      }
    });
  }
}