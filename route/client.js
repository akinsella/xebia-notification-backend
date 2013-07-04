// Generated by CoffeeScript 1.6.3
var Client, apn, create, findById, list, removeById, utils, _;

utils = require('../lib/utils');

_ = require('underscore')._;

apn = require('apn');

Client = require("../model/client");

create = function(req, res) {
  var client;
  client = new Client(req.body);
  return client.save(function(err) {
    if (err) {
      utils.responseData(500, "Could not save client", req.body, {
        req: req,
        res: res
      });
    } else {
      utils.responseData(201, "Created", client, {
        req: req,
        res: res
      });
    }
  });
};

list = function(req, res) {
  return Client.find({}, function(err, clients) {
    utils.responseData(200, void 0, clients, {
      req: req,
      res: res
    });
  });
};

findById = function(req, res) {
  return Client.findOne({
    id: req.params.id
  }, function(err, client) {
    if (client) {
      utils.responseData(200, void 0, client, {
        req: req,
        res: res
      });
    } else {
      utils.responseData(404, "Not Found", void 0, {
        req: req,
        res: res
      });
    }
  });
};

removeById = function(req, res) {
  return Client.findOneAndRemove({
    id: req.params.id
  }, function(err, client) {
    if (client) {
      utils.responseData(204, void 0, client, {
        req: req,
        res: res
      });
    } else {
      utils.responseData(404, "Not Found", void 0, {
        req: req,
        res: res
      });
    }
  });
};

module.exports = {
  create: create,
  list: list,
  findById: findById,
  create: create,
  removeById: removeById
};