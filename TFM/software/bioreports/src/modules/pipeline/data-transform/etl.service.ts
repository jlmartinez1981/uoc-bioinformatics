import { FileService } from '../../repository/file.service';
import * as path from 'path';
import { ExternalProcess } from '../../utils/external.process';

/**
 * ETLService
 *
 * @class ETLService
 * @description
 */
export class ETLService {

    private static instance: ETLService;
    private fileService: FileService;

    /**
     * Constructor.
     *
     * @class ETLService
     * @constructor
     */
    constructor() {
        if (ETLService.instance) {
            throw 'ETLService instance already exists. Please use ETLService.getInstance()';
        }
    }

    public static getInstance(): ETLService {
        if (ETLService.instance) {
            return ETLService.instance;
        }
        return new ETLService();
    }

    public transform(filePath: string, fileName: string): Promise<any> {
        return new Promise((resolve, reject) => {
            // do something asynchronous which eventually calls either:
            //
            //   resolve(someValue); // fulfilled
            // or
            //   reject("failure reason"); // rejected
            const etlFileName = path.join(filePath, fileName);
            const newFile = path.join(FileService.PROCESSED_PATH, fileName);
            console.log('TRANSFORMING TO: ', newFile);
            const scriptData = {fileToWrite: newFile, fileToRead: etlFileName};

            const scriptPath = path.join(__dirname, '../../../r-scripts', 'etl.R');
            const externalProcessResult = ExternalProcess.executeRScript(scriptPath, scriptData);
            setTimeout(function() {
                resolve('upload_processed/'.concat(etlFileName));
              }, 250);
            // resolve('upload_processed/'.concat(etlFileName));
        });
    }
}