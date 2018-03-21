import * as express from 'express';
import * as bodyParser from 'body-parser';
import * as cookieParser from 'cookie-parser';
import * as logger from 'morgan';
import * as path from 'path';
import * as errorHandler from 'errorhandler';
import * as methodOverride from 'method-override';


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
    /**
     * Error Handler. Provides full stack - remove for production
     */
    this.app.use(errorHandler());

    // static  files mapped to a virtual directory
    this.app.use('/static', express.static(path.join(__dirname, '../../public')));

    // app = config(app);

    this.app.get('/', function(req: express.Request, res: express.Response) {
      // res.send('Hello world!');
      res.sendFile(path.join(__dirname + '../../../views/index.html'));
  });

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
    // empty for now
  }
}