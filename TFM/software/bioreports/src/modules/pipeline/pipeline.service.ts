import { ETLService } from './data-transform/etl.service';
import { ReportService } from './report/report.service';
import * as path from 'path';
import { ExternalProcess } from '../utils/external.process';
import { FileService } from '../repository/file.service';


/**
 * PipelineService
 *
 * @class PipelineService
 * @description
 */
export class PipelineService {

    private static instance: PipelineService;
    private etlService: ETLService;
    private reportService: ReportService;
    /**
     * Constructor.
     *
     * @class PipelineService
     * @constructor
     */
    constructor() {
        if (PipelineService.instance) {
            throw 'PipelineService instance already exists. Please use PipelineService.getInstance()';
        }
        this.etlService = ETLService.getInstance();
        this.reportService = ReportService.getInstance();
    }

    public static getInstance(): PipelineService {
        if (PipelineService.instance) {
            return PipelineService.instance;
        }
        return new PipelineService();
    }

    public backgroundReportGenerationProcess(filePath: string, fileName: string): Promise<any> {
        return new Promise((resolve, reject) => {
            const etlFileName = path.join(filePath, fileName);
            const newFile = path.join(FileService.PROCESSED_PATH, fileName.replace('.txt', '.csv'));
            // console.log('TRANSFORMING TO: ', newFile);
            console.log('EXECUTING PIPELINE TO: ', fileName);
            const scriptData = {fileToWrite: newFile, fileToRead: etlFileName};
            const scriptPath = path.join(__dirname, '../../r-scripts', 'pipeline-test.R');
            try {
                const externalProcessResult = ExternalProcess.executeRScript(scriptPath, scriptData);
                resolve(true);
            } catch (err) {
                reject(err);
            }
        });
        /*
        console.log(`Starting ETL process for file ${fileName}`);
        return new Promise((resolve, reject) => {
            const transformedPromise = this.etlService.transform(filePath, fileName, trimSpaces);
            transformedPromise.then((result: any) => {
                console.log(`${filePath}/${fileName} transformed to ${result}`);
                console.log(`Starting report generation for file ${fileName}`);

                const reportPromise = this.reportService.generateReport(result, fileName);
                reportPromise.then((result: any) => {
                    console.log(`${filePath} report generated for file ${result}`);
                    resolve(true);
                    }).catch((err: any) => {
                        console.error(`Error transforming file ${filePath}: ${err}`);
                        reject(err);
                    });
                }).catch((err: any) => {
                console.error(`Error transforming file ${filePath}: ${err}`);
            });
        });
        */
      }
}