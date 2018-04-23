import * as child from 'child_process';
import * as path from 'path';

/**
 * External process
 *
 * @class ExternalProcess
 * @description
 */
export class ExternalProcess {

    public static executeRScript(scriptPath: string, scriptArgs: any): any {
        const r_comm = 'Rscript';
        console.log('R PATH: ', scriptPath);
        const processArgs: Array<string> = ['--vanilla', '--slave', scriptPath];
        processArgs.push(scriptArgs.fileToRead);
        processArgs.push(scriptArgs.fileToWrite);
        processArgs.push(scriptArgs.reportFile);
        processArgs.push(scriptArgs.transformationsFile);

        const rspawn = child.spawn(r_comm, processArgs);

        rspawn.stdout.on('data', function (data) {
            console.log('STDOUT: \n');
            console.log(data.toString());
        });

        rspawn.stderr.on('data', function (data) {
            console.log('STDERR: \n');
            console.log(data.toString());
        });

        rspawn.on('close', function (code) {
            console.log('child process exited with code ' + code);
        });
    }
}