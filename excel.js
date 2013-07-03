
//Excel parser test
var parseXlsx = require('excel');
var fs = require('fs');
var liner = require('liner');
//var sheetStream = fs.createReadStream('./test.xlsx');
var sheetStream = fs.createReadStream('./indice.xlsx');

//parseXlsx(sheetStream, function(err, data) {
parseXlsx('./indice.xlsx', function(err, data) {
  if (err) throw err;

//  console.log(data);
  console.log('d[0]');
  console.log(data[0]);
  console.log('d[0][0]');
  console.log(data[0][0]);
});
/*
sheetStream.pipe(liner);

liner.on('readable', function() {
  var line;
  while (line = liner.read()) {
    //parseXlsx(sheetStream, function(err, data) {
    parseXlsx(line, function(err, data) {
      if (err) throw err;

      console.log(data);
      console.log('d[0]');
      console.log(data[0]);
      console.log('d[0][0]');
      console.log(data[0][0]);
    });
  }
});
*/

