
/*
 * GET home page.
 */

exports.test = function(req, res){
  res.render('index', { title: 'Test.test' });
};

exports.wong = function(req, res){
  res.render('index', { title: 'Test.wong' });
};
