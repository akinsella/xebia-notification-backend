// Generated by CoffeeScript 1.6.3
var CacheEntry, clear, get, moment, remove, set;

CacheEntry = require('../model/cacheEntry');

moment = require('moment');

get = function(key, callback) {
  return CacheEntry.findOne({
    key: key
  }, function(err, cacheEntry) {
    var lastModified, lastModifiedWithTtl, now;
    if (err || !cacheEntry) {
      if (callback) {
        return callback(err, void 0);
      }
    } else {
      now = moment();
      lastModified = moment(cacheEntry.lastModified);
      if (cacheEntry.ttl === -1) {
        if (callback) {
          return callback(err, JSON.parse(cacheEntry.data));
        }
      } else {
        lastModifiedWithTtl = lastModified.add('seconds', cacheEntry.ttl);
        if (now.isAfter(lastModifiedWithTtl)) {
          cacheEntry.remove();
          if (callback) {
            return callback(err, void 0);
          }
        } else {
          if (callback) {
            return callback(err, JSON.parse(cacheEntry.data));
          }
        }
      }
    }
  });
};

set = function(key, data, ttl, callback) {
  var cacheEntry;
  cacheEntry = new CacheEntry({
    key: key,
    data: JSON.stringify(data),
    ttl: ttl
  });
  return CacheEntry.remove({
    key: key
  }, function(err) {
    if (err) {
      if (callback) {
        return callback(err);
      }
    } else {
      return cacheEntry.save(function(err) {
        if (callback) {
          return callback(err);
        }
      });
    }
  });
};

remove = function(key, callback) {
  return CacheEntry.findOneAndRemove({
    key: key
  }, function(err, cacheEntry) {
    if (callback) {
      return callback(err, cacheEntry);
    }
  });
};

clear = function(callback) {
  return CacheEntry.findAndRemove({}, function(err) {
    if (callback) {
      return callback(err);
    }
  });
};

module.exports = {
  get: get,
  set: set,
  remove: remove,
  clear: clear
};
