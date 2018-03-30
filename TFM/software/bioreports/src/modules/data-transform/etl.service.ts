import { FileService } from '../repository/file.service';

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

    public transform(): Promise<any> {
        return new Promise((resolve, reject) => {
            // do something asynchronous which eventually calls either:
            //
            //   resolve(someValue); // fulfilled
            // or
            //   reject("failure reason"); // rejected
            resolve(true);
        });
    }
}