var mongoose = require('mongoose')
  , Schema = mongoose.Schema;

var recordSchema = new Schema({
  setName: {type: String, default: ''}
});

recordSchema.methods.hable = function() {
  var greeting = this.name
    ? "Ya este es record: " + this.name 
    : "No tengo un nombre";
  return greeting;
}

recordSchema.statics = {
  list: function (options, callback) {
    this.find()
      .exec(callback);
  }
}

mongoose.model('Record', recordSchema);
