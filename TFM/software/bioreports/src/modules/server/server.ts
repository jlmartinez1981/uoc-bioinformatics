import * as express from 'express';
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
import { DateUtils } from '../utils/date.utils';
import { PipelineService } from '../pipeline/pipeline.service';
// import { appLogger } from '../logger/log4js.logger';
import * as csvToJson from 'csvtojson';
import { EOL } from 'os';
import { OmicService } from '../pipeline/data-access/omic.service';
import { ReportUtils } from '../utils/report.utils';

/**
 * The server.
 *
 * @class Server
 */
export class Server {

  public app: express.Application;
  private fileService: FileService;
  private omicService: OmicService;
  private pipeline: PipelineService;

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
    this.pipeline = PipelineService.getInstance();
    this.omicService = OmicService.getInstance();
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
      res.render('pages/index', {uploadResult: undefined});
    });

    // ejs test https://scotch.io/tutorials/use-ejs-to-template-your-node-application
    this.app.get('/uploads', function(req: express.Request, res: express.Response) {
      try {
        const uploadPath = FileService.UPLOAD_PATH;
        const files = that.fileService.listFiles(uploadPath);
        res.render('pages/uploadsList', {uploadfiles: files});
      } catch (err) {
        console.error(`Error showing uploaded  files page: ${err}`);
        return res.render('pages/error', {error: err});
      }
    });

    this.app.get('/reports', function(req: express.Request, res: express.Response) {
      try {
        const diseaseReportsPath = FileService.DISEASE_REPORTS_PATH;
        const diseaseFiles = that.fileService.listFiles(diseaseReportsPath);

        const ancestryReportsPath = FileService.ANCESTRY_REPORTS_PATH;
        const ancestryFiles = that.fileService.listFiles(ancestryReportsPath);
        res.render('pages/reportsList', {diseaseReportFiles: diseaseFiles, ancestryReportFiles: ancestryFiles});
      } catch (err) {
        console.error(`Error showing reports page: ${err}`);
        return res.render('pages/error', {error: err});
      }
    });

    this.app.get('/details', function(req: express.Request, res: express.Response) {
      const report: any = {fileName: req.query.report, diseases: undefined, nutrigenomics: undefined,
         reportType: req.query.reportType};
      const reportData: Array<object> = new Array<object>();
      const reportsPath = path.join((req.query.reportType == 1 ? FileService.DISEASE_REPORTS_PATH : FileService.ANCESTRY_REPORTS_PATH ), req.query.report);
      try {
        console.log(`REPORT ${reportsPath}`);
        const csv = csvToJson;
        csv({noheader: false})
            .fromFile(reportsPath)
            .on('json', ( json: any ) => {
              console.log(json);
              if (json.diseases) {
                let diseasesArray: Array<string> = new Array<string>();
                // const dis: any = json.diseases;
                diseasesArray = json.diseases.split('#');
                json.diseases = diseasesArray;
              }
              reportData.push(json);
        })
        .on('done', async () => {
            console.log(`END REPORT ${reportsPath}`);
            if (req.query.reportType == 1) {
              report['diseases'] = reportData;
              // nutrigenomics
              const geneNames = ReportUtils.extractGenesFromReport(reportData);
              const nutrigenomics: Array<object> = that.omicService.getNutrigeneticsFromGenes(geneNames);
              report['nutrigenomics'] = nutrigenomics;
            } else if (req.query.reportType == 2) {
              report['ancestry'] = reportData;
            }
            res.render('pages/details', {details: report});
        });
      } catch (err) {
        console.error(`Error showing reports page for ${reportsPath}: ${err}`);
        return res.render('pages/error', {error: err});
      }
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
    this.app.post('/uploadFile', async function(req, res, next) {
      console.log('UPLOADING FILE...');
      try {
        const uploadsPath = FileService.UPLOAD_PATH;
        const dateStr: string = DateUtils.dateFormat(Date.now(), 'yyyymmddHHMMss');
        if (Object.keys(req.files).length === 0 && req.files.constructor === Object) {
          // the rest of parameters come in req.body
          const params: any = req.body;
          let snpFileName: string = undefined;
          let storageName: string = undefined;
          let reportType: string = '1'; // human diseases by default
          if (SnpUtils.checkSNPText(params.snpText)) {
            reportType = params.reportType;
            snpFileName = (params.fileName !== '' ? params.fileName : 'anonymous');
            if ( reportType == '1' ) {
              storageName = dateStr.concat('-disease-', snpFileName, '.txt');
            } else {
              storageName = dateStr.concat('-ancestry-', snpFileName, '.txt');
            }
            const storagePath = path.join(uploadsPath, storageName);
            console.log('SnpFileName: ', storagePath);
            let snpText: string = params.snpText;
            // check for end of line character
            const lastChar =  snpText.slice(-1);
            const match = /\r\n|\r|\n/g.exec(lastChar);
            if (!match) {
              // Found one, look at `match` for details, in particular `match.index`
              snpText = snpText.concat(EOL);
            }
            const fileUploadPromise = that.fileService.saveFile(storagePath, snpText);
            fileUploadPromise.then( (result) => {
              console.log(`${storageName} file uploaded to ${storagePath}`);
              res.render('pages/index', {uploadResult: storageName});
              that.pipeline.backgroundReportGenerationProcess(reportType, uploadsPath, storageName);
            }).catch(err => {
              console.error(`Failed to upload file ${storagePath}: ${err}`);
              return res.render('pages/error', {error: err});
            });
          }
        } else {
          // Save file if it exists
          // The name of the input field (i.e. "sampleFile") is used to retrieve the uploaded file
          const snpFile: any = req.files ? req.files.snpFile : undefined;
          if (!snpFile) {
            throw 'Upload file: No file provided!';
          }

          let fileName: string = undefined;
          const reportType: string = req.body.reportType;
          if ( reportType == '1' ) {
            fileName = dateStr.concat('-disease-', snpFile.name);
          } else {
            fileName = dateStr.concat('-ancestry-', snpFile.name);
          }

          const filePath = path.join(uploadsPath, fileName);
          // Use the mv() method to place the file somewhere on your server
          const fileUploadPromise = snpFile.mv(filePath);
          fileUploadPromise.then((result: any) => {
            console.log(`${fileName} file uploaded to ${filePath}`);
            res.render('pages/index', {uploadResult: `${fileName}`});
            that.pipeline.backgroundReportGenerationProcess(reportType, uploadsPath, fileName);
          }).catch((err: any) => {
            console.error(`Error uploading file to ${filePath}: ${err}`);
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