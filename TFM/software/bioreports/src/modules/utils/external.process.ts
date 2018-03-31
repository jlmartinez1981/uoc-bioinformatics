import * as R from 'r-script';
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
        // const r_comm = 'pwd';
        // const rfilePath = path.join(__dirname, '../../r-scripts/helloworld.R');
        console.log('R PATH: ', scriptPath);
        const processArgs: Array<string> = ['--vanilla', '--slave', scriptPath];
        processArgs.push(scriptArgs.fileToWrite);
        processArgs.push(scriptArgs.fileToRead);

        const rspawn = child.spawn(r_comm, processArgs);
        // const rspawn = child.spawn(r_comm);

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
        /*
        const out = R(scriptPath)
        .data({scriptArgs: scriptArgs})
        .callSync();

        console.log(out);
        return out;
        */
        // Rscript --vanilla .\src\r-scripts\helloworld.R 'hola' 'adios' 1
        // async
        /*
        R(scriptPath)
        .data({scriptArgs: scriptArgs})
        .call(function(err, d) {
            if (err)
                throw err;
            console.log(d);
            return d;
        });*/
    }
}