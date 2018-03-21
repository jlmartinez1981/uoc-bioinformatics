var fs = require('fs');
var pjson = require('../package.json');
var write = fs.createWriteStream;
var pack = require('tar-pack').pack;
var path = require('path');
 
var dir = path.join(__dirname,'../release/');
 
if (!fs.existsSync(dir)){
    fs.mkdirSync(dir);
}
pack(path.join(__dirname,'../dist/'),{fromBase:true})
  .pipe(write(path.join(__dirname,`../release/package-${pjson.version}.tar.gz`))
  .on('error', function (err) {
    console.error(err.stack);
  })
  .on('close', function () {
    console.log('done');
  }));
  