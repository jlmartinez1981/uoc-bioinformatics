import * as shell from 'shelljs';

shell.cp('-R', 'src/views', 'dist/views/');
shell.cp('-R', 'src/r-scripts', 'dist/r-scripts/');
shell.cp('-R', 'src/public', 'dist/public/');