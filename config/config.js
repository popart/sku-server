var path = require('path')
  , rootPath = path.normalize(__dirname + '/..');

module.exports = {
  development: {
    db: 'mongodb://localhost/fda_dev',
    root: rootPath,
    app: {
      name: 'FDA Super Database'
    }
  }
}
