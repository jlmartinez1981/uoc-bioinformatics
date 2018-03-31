import * as R from 'r-script';
/**
 * External process
 *
 * @class ExternalProcess
 * @description
 */
export class ExternalProcess {

    public static executeRScript(scriptPath: string, scriptArgs: any): any {
        const out = R(scriptPath)
        .data({scriptArgs: scriptArgs})
        .callSync();

        console.log(out);
        return out;

        // async
        /*
        R(scriptPath)
        .data({df: {h: 'hello world'}, nGroups: 3, fxn: 'mean' })
        .call(function(err, d) {
            if (err)
                throw err;
            console.log(d);
        });
        */
    }
}