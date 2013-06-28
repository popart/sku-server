// required in ~/config/routes.js

var mongoose = require('mongoose')
  , Record = mongoose.model('Record')
  , utils = require('../../lib/utils');
  //, _ = require('underscore');

/**
 * List
 */

exports.index = function(req, res) {
  var page = (req.param('page') > 0 ? req.param('page') : 1) -1;
  var perPage = 30;
  var options = {
    perPage: perPage,
    page: page
  }

  Record.list(options, function(err, records) {
    if(err) return res.render('500');
    Record.count().exec(function(err, count) {
      res.render('records/index', { //views
        title: 'All Records',
        records: records,
        page: page+1,
        pages: Math.ceil(count / perPage)
      });
    });
  });
}
