import { ETLService } from './data-transform/etl.service';
import { ReportService } from './report/report.service';

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

    public backgroundReportGenerationProcess(filePath: string, fileName: string): void {
        console.log(`Starting ETL process for file ${fileName}`);

        const transformedPromise = this.etlService.transform(filePath, fileName);
        transformedPromise.then((result: any) => {
          console.log(`${filePath}/${fileName} transformed to ${result}`);
          console.log(`Starting report generation for file ${fileName}`);

          const reportPromise = this.reportService.generateReport(result, fileName);
          reportPromise.then((result: any) => {
              console.log(`${filePath} report generated for file ${result}`);
            }).catch((err: any) => {
              console.error(`Error transforming file ${filePath}: ${err}`);
              });
          }).catch((err: any) => {
            console.error(`Error transforming file ${filePath}: ${err}`);
        });
      }
}