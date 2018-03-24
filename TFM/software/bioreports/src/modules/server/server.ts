import * as express from 'express';
import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as logger from 'morgan';
import * as path from 'path';
import * as errorHandler from 'errorhandler';
import * as methodOverride from 'method-override';
import * as compression from 'compression'; // compresses requests
import * as formidable from 'formidable';
import * as fs from 'fs';

/**
 * The server.
 *
 * @class Server
 */
export class Server {

  public app: express.Application;

  /**
   * Bootstrap the application.
   *
   * @class Server
   * @method bootstrap
   * @static
   * @return {ng.auto.IInjectorService} Returns the newly created injector for this app.
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
    // create expressjs application
    this.app = express();

    // configure application
    this.config();

    // add routes
    this.routes();

    // add api
    this.api();
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
    this.app.set('views', __dirname + '../../views');
    this.app.set('view engine', 'ejs');
    this.app.use(compression());
    this.app.use(bodyParser.json());
    this.app.use(bodyParser.urlencoded({ extended: true }));
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
      console.log('Rules Server up: http://localhost:', listeningPort);
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
      res.sendFile(path.join(__dirname + '../../../views/index.html'));
    });

    // upload
    this.app.post('/upload', function(req, res, next) {
      console.log('UPLOADING FILE: ', req.params.files); // the uploaded file object
      next();
    });

    // upload
    this.app.post('/upload', function(req, res, next) {
      console.log('UPLOADING FILE...');
      // create an incoming form object
      const form = new formidable.IncomingForm();

      // specify that we want to allow the user to upload multiple files in a single request
      // form.multiples = true;

      // store all uploads in the /uploads directory
      form.uploadDir = path.join(__dirname, '/uploads');

      // every time a file has been uploaded successfully,
      // rename it to it's orignal name
      form.on('file', function(field, file) {
        fs.rename(file.path, path.join(form.uploadDir, file.name), (err) => {
          if (err) {
            throw err;
          }
          console.log('Rename complete!');
        });
      });

      // log any errors that occur
      form.on('error', function(err) {
        console.log('An error has occured: \n' + err);
      });

      // once all the files have been uploaded, send a response to the client
      form.on('end', function() {
        console.log('FILE UPLOADED: ', req.params.files); // the uploaded file object
        res.end('success');
      });

      // parse the incoming request containing the form data
      form.parse(req);

    });
  }
}