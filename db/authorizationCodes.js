// Generated by CoffeeScript 1.6.3
var AuthorizationCode, apn, utils, _;

utils = require('../lib/utils');

_ = require('underscore')._;

apn = require('apn');

AuthorizationCode = require("../model/authorizationCode");

exports.find = function(code, done) {
  return AuthorizationCode.find({
    code: code
  }, function(err, authorizationCode) {
    if (err) {
      return done(err, null);
    } else {
      return done(null, authorizationCode);
    }
  });
};

exports.save = function(code, clientID, redirectURI, userID, done) {
  var authorizationCode;
  authorizationCode = new AuthorizationCode({
    clientID: clientID,
    redirectURI: redirectURI,
    userID: userID
  });
  return authorizationCode.save(function(err) {
    if (err) {
      return done(err);
    } else {
      return done(null);
    }
  });
};
