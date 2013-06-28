
/**
 * Module dependencies.
 */

var express = require('express')
  , fs = require('fs')
  , path = require('path');
/*
  , routes = require('./routes')
  , user = require('./routes/user')
  , test = require('./routes/test')
  , http = require('http')
*/

// Load configs
var env = process.env.NODE_ENV || 'development'
  , config = require('./config/config')[env];

var app = express();
var mongoose = require('mongoose');

// bootstrap db connection
//mongoose.connect('mongodb://localhost/fda_dev');
mongoose.connect(config.db);

// bootstrap models
var models_path = __dirname + '/app/models';
fs.readdirSync(models_path).forEach(function (file) {
  if(~file.indexOf('.js') && !~file.indexOf('.js~') && !~file.indexOf('.swp')) 
    require(models_path + '/' + file);
});
//schemas = require('./schemas/test'); //which isn't even a schema

// express settings
require('./config/express') (app, config);

// bootstrap routes
require('./config/routes') (app);

// just some test code
var db = mongoose.connection;
db.on('error', console.error.bind(console, 'mongo connection error:'));
db.once('open', function callback() {
  console.log("connected to mongodb");
});

// all environments
/* 
app.set('port', process.env.PORT || 3000);
app.set('views', __dirname + '/views');
app.set('view engine', 'ejs');
app.use(express.favicon());
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(express.cookieParser('your secret here'));
app.use(express.session());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));
*/

// development only
//if ('development' == app.get('env')) {
if (env = 'development') {
  app.use(express.errorHandler());
}

/*
app.get('/', routes.index);
app.get('/test', test.test);
app.get('/test/wong', test.wong);
app.get('/users', user.list);
app.get('/schemas', schemas.test);
*/

/*
http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});
*/

var port = process.env.PORT || 3000;
app.listen(port);
console.log('Express app started on port ' + port);

// expose app
exports = module.exports = app;
