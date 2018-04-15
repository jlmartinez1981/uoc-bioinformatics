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

    public backgroundReportGenerationProcess(reportType: string, filePath: string, fileName: string): Promise<any> {
        return new Promise((resolve, reject) => {
            switch (reportType) {
                case '1':
                    console.log('EXECUTING DISEASE PIPELINE TO: ', fileName);

                    const diseaseEtlFileName = path.join(filePath, fileName);
                    const diseaseNewFile = path.join(FileService.PROCESSED_PATH, fileName.replace('.txt', '.csv'));
                    const diseaseReportFileName = path.join(FileService.REPORTS_PATH, fileName.replace('.txt', '.csv'));

                    const diseaseScriptData = {fileToWrite: diseaseNewFile, fileToRead: diseaseEtlFileName,
                         reportFile: diseaseReportFileName};
                    const diseaseScriptPath = path.join(__dirname, '../../r-scripts', 'disease-pipeline-test.R');
                    try {
                        const externalProcessResult = ExternalProcess.executeRScript(diseaseScriptPath, diseaseScriptData);
                        resolve(true);
                    } catch (err) {
                        reject(err);
                    }
                    break;
                case '2':
                    console.log('EXECUTING ANCESTOR PIPELINE TO: ', fileName);

                    const ancestryEtlFileName = path.join(filePath, fileName);
                    // do not change .txt by .csv
                    const ancestryNewFile = path.join(FileService.PROCESSED_PATH, fileName);
                    const ancestryReportFileName = path.join(FileService.REPORTS_PATH, fileName.replace('.txt', '.csv'));

                    const ancestryScriptData = {fileToWrite: ancestryNewFile, fileToRead: ancestryEtlFileName,
                         reportFile: ancestryReportFileName};
                    const ancestryScriptPath = path.join(__dirname, '../../r-scripts', 'ancestry-pipeline-test.R');
                    try {
                        const externalProcessResult = ExternalProcess.executeRScript(ancestryScriptPath, ancestryScriptData);
                        resolve(true);
                    } catch (err) {
                        reject(err);
                    }
                    break;
                default:
                    break;
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