
/*
 * GET home page.
 */

exports.test = function(req, res){
  //how to inject "db"?
  var x = db.fda_dev.findOne();
  res.render('test', { 
    title: 'Schema.test',
    record: x
  });
};

exports.wong = function(req, res){
  res.render('index', { title: 'Test.wong' });
};
