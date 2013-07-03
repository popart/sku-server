// required in ~/config/routes.js

var mongoose = require('mongoose')
  , Record = mongoose.model('Record')
  , utils = require('../../lib/utils');
  //, _ = require('underscore');

// used for any :id param
exports.load = function(req, res, next, id) {
  Record.load(id, function(err, record) {
    if (err) return next(err);
    if (!record) return next(new Error('not found'));

    req.record = record;
    next();
  });
};

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
      console.log('## count: '+count);
      res.render('records/index', { //views
        title: 'All Records',
        records: records,
        page: page+1,
        pages: Math.ceil(count / perPage)
      });
    });
  });
}

// READ
exports.view = function (req, res) {
  console.log(req.record);
  res.render('records/view', {
    title: 'View Record',
    record: req.record //from .load
  });
};

// CREATE
exports.new = function(req, res) {
  res.render('records/new', {
    title: 'New Record',
    record: new Record({})
  });
};

exports.create = function (req, res) {
  console.log('### create');
  console.log(req.body);
  var record = new Record(req.body);

  record.save(function (err) {
    if (!err) {
      req.flash('success', 'Made a record, son');
      return res.redirect('/');
    }
    
    //otherwise some problem => go back to form
    res.render('records/new', { //view
      title: 'New Record',
      record: record,
      errors: utils.errors(err.errors || err)
    });
  });
};

