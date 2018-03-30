/**
 * FileService
 *
 * @class FileService
 * @description
 */
export class FileService {

    private static instance: FileService;
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
    public saveFile(filePath: string, fileContents: any): boolean {
        // TODO save file
        return false;
    }

    /**
     *
     */
    public getFile(): void {
        // TODO readFile and return the data
    }

    public listFiles(dirPath: string): Array<string> {
        const files: Array<string> = new Array<string>();
        return files;
    }
}