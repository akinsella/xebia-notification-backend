// Generated by CoffeeScript 1.6.3
var Notification, mongo, notificationModel, pureautoinc;

mongo = require('../lib/mongo');

pureautoinc = require('mongoose-pureautoinc');

Notification = new mongo.Schema({
  id: Number,
  message: {
    type: String,
    "default": '',
    trim: true
  }
});

notificationModel = mongo.client.model('Notification', Notification);

Notification.plugin(pureautoinc.plugin, {
  model: 'Notification',
  field: 'id'
});

module.exports = notificationModel;