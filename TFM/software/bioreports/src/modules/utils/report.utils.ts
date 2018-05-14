/**
 * ReportUtils
 *
 * @class ReportUtils
 * @description
 */
export class ReportUtils {

    public static extractGenesFromReport(reportData: any[]): Array<string> {
        const geneNames: Array<string> = new Array<string>();
        reportData.forEach(element => {
            geneNames.push(element.gene_name);
        });
        return geneNames;
    }
}