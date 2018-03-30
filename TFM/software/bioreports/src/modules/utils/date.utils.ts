import * as dateFormat from 'dateformat';
/**
 * DateUtils
 *
 * @class DateUtils
 * @description
 */
export class DateUtils {

    public static dateFormat(date: number, format: string): string {
        return dateFormat(date, format);
    }
    public static extractDateFromFilename(fileName: string): string {
        const dateIndex: number = fileName.indexOf('-');
        if (dateIndex > -1) {
            return fileName.substring(0, dateIndex);
        }
        return 'no date';
    }
}