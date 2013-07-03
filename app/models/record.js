var mongoose = require('mongoose')
  , Schema = mongoose.Schema;

var recordSchema = new Schema({
  setName: {type: String, default: ''}
});

recordSchema.methods = {
  hable: function() {
    var greeting = this.setName
      ? "Ya este es record: " + this.setName 
      : "No tengo un nombre";
    return greeting;
  },
  /*
  save: function(callback) {
    self.save(callback);
  }
  */
}

recordSchema.statics = {
  load: function(id, callback) {
    this.findOne({_id: id})
      .exec(callback);
  },

  list: function(options, callback) {
    this.find()
      .exec(callback);
  }
}

mongoose.model('Record', recordSchema);
