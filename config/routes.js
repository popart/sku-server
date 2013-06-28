/*
 * Module dep
 */

//var async = require('async');

/**
 * Controllers
 */

/*
var users = require('../app/controllers/users')
  , articles = require('../app/controllers/articles')
  , auth = require('.middlewares/authorization');
*/
var records = require('../app/controllers/records');

/**
 * Route middlewares
 */

//var articleAuth = [auth.requiresLogin, auth.article.hasAuthorization];

/**
 * Expose routes
 */

//module.exports = function (app, passport) {
module.exports = function (app) {

  // home route
  app.get('/', records.index);
 
  /*
  //user routes
  app.get('/login', users.login);
  app.get('/signup', users.signup);
  app.get('/logout', users.logout);
  app.post('/users', users.create);
  app.post('/users/session',
      passport.authenticate('local', {
        failureRedirect: '/login',
        failureFlash: 'Invalid email or password.'
      }), users.session);

  app.param('userId', users.user);

  //article routes
  app.get('/articles', articles.index);

  app.param('id', articles.load);

  // tag routes
  var tags = require('../app/controllers/tags');
  app.get('/tags/:tag', tags.index);
  */
}

