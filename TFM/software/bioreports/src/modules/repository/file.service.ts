import * as fs from 'fs';
import * as path from 'path';
import { DateUtils } from '../utils/date.utils';
/**
 * FileService
 *
 * @class FileService
 * @description
 */
export class FileService {

    private static instance: FileService;
    public static APP_PATH: string = path.join(process.env.USERPROFILE, 'bioreports');
    public static REPORTS_PATH: string = path.join(process.env.USERPROFILE, 'bioreports/reports');
    public static DISEASE_REPORTS_PATH: string = path.join(process.env.USERPROFILE, 'bioreports/reports/disease');
    public static ANCESTRY_REPORTS_PATH: string = path.join(process.env.USERPROFILE, 'bioreports/reports/ancestry');

    public static UPLOAD_PATH: string = path.join(process.env.USERPROFILE, 'bioreports/upload');
    public static PROCESSED_PATH: string = path.join(process.env.USERPROFILE, 'bioreports/upload_processed');
    public static PROCESSED_TRANSFORMATIONS_PATH: string = path.join(process.env.USERPROFILE, 'bioreports/upload_processed/transformations');

    /**
     * Constructor.
     *
     * @class FileService
     * @constructor
     */
    constructor() {
        if (FileService.instance) {
            throw 'FileService instance already exists. Please use FileService.getInstance()';
        }
        // init paths
        this.createDirIfnotExists(FileService.APP_PATH);
        this.createDirIfnotExists(FileService.REPORTS_PATH);
        this.createDirIfnotExists(FileService.DISEASE_REPORTS_PATH);
        this.createDirIfnotExists(FileService.ANCESTRY_REPORTS_PATH);
        this.createDirIfnotExists(FileService.UPLOAD_PATH);
        this.createDirIfnotExists(FileService.PROCESSED_PATH);
        this.createDirIfnotExists(FileService.PROCESSED_TRANSFORMATIONS_PATH);
    }

    public static getInstance(): FileService {
        if (FileService.instance) {
            return FileService.instance;
        }
        return new FileService();
    }

    /**
     *
     * @param filePath
     * @param fileContents
     */
    public saveFile(filePath: string, fileContents: string): Promise<any> {
        return new Promise<any>((resolve, reject) => {
            try {
                fs.writeFileSync(filePath, fileContents);
                resolve(true);
            } catch (err) {
                reject(err);
            }
        });
    }

    public listFiles(dirPath: string): Array<object> {
        const files: Array<object> = new Array<object>();
        fs.readdirSync(dirPath).forEach(file => {
            console.log(file);
            const fileDate: string = DateUtils.extractDateFromFilename(file);
            files.push({name: file, date: fileDate});
        });

        return files;
    }

    public createDirIfnotExists (dirPath: string) {
        if (!fs.existsSync(dirPath)) {
            fs.mkdirSync(dirPath);
          }
    }
}