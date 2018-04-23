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
                    const diseaseReportFileName = path.join(FileService.DISEASE_REPORTS_PATH, fileName.replace('.txt', '.csv'));
                    // directory for PLINK trnasformations
                    const diseaseTransformationsFileName = path.join(FileService.PROCESSED_TRANSFORMATIONS_PATH, fileName.replace('.txt', ''));

                    const diseaseScriptData = {fileToWrite: diseaseNewFile, fileToRead: diseaseEtlFileName,
                         reportFile: diseaseReportFileName, transformationsFile: diseaseTransformationsFileName};
                    const diseaseScriptPath = path.join(__dirname, '../../r-scripts', 'disease-pipeline-test.R');
                    try {
                        const externalProcessResult = ExternalProcess.executeRScript(diseaseScriptPath, diseaseScriptData);
                        resolve(true);
                    } catch (err) {
                        reject(err);
                    }
                    break;
                case '2':
                    console.log('EXECUTING ANCESTRY PIPELINE TO: ', fileName);

                    const ancestryEtlFileName = path.join(filePath, fileName);
                    // do not change .txt by .csv
                    const ancestryNewFile = path.join(FileService.PROCESSED_PATH, fileName);
                    const ancestryReportFileName = path.join(FileService.ANCESTRY_REPORTS_PATH, fileName.replace('.txt', '.csv'));
                    // directory for PLINK trnasformations
                    const ancestryTransformationsFileName = path.join(FileService.PROCESSED_TRANSFORMATIONS_PATH, fileName.replace('.txt', ''));

                    const ancestryScriptData = {fileToWrite: ancestryNewFile, fileToRead: ancestryEtlFileName,
                         reportFile: ancestryReportFileName, transformationsFile: ancestryTransformationsFileName};
                    const ancestryScriptPath = path.join(__dirname, '../../r-scripts', 'ancestry-pipeline.R');
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
      }
}