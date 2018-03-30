import { OmicService } from '../data-access/omic.service';
import { FileService } from '../repository/file.service';
import { ETLService } from '../data-transform/etl.service';

/**
 * ReportService
 *
 * @class ReportService
 * @description
 */
export class ReportService {

    private static instance: ReportService;
    private omicService: OmicService;
    private fileService: FileService;

    /**
     * Constructor.
     *
     * @class ReportService
     * @constructor
     */
    constructor() {
        if (ReportService.instance) {
            throw 'ReportService instance already exists. Please use ReportService.getInstance()';
        }
        this.omicService = new OmicService();
        this.fileService = FileService.getInstance();
    }

    public static getInstance(): ReportService {
        if (ReportService.instance) {
            return ReportService.instance;
        }
        return new ReportService();
    }

    public generateReport(filePath: string, fileName: string): Promise<any> {
        return new Promise((resolve, reject) => {
            // do something asynchronous which eventually calls either:
            //
            //   resolve(someValue); // fulfilled
            // or
            //   reject("failure reason"); // rejected
            const reportFileName = fileName;
            setTimeout(function() {
                resolve('reports/'.concat(reportFileName));
              }, 250);
            // resolve('reports/'.concat(reportFileName));
        });
    }
}