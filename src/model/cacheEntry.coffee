mongo = require '../lib/mongo'
pureautoinc  = require('mongoose-pureautoinc');

CacheEntry = new mongo.Schema(
	id: Number,
	key: String,
	data: String,
	ttl: Number,
	createAt: { type: Date, "default": Date.now }
	lastModified: { type: Date, "default": Date.now }
)

cacheEntryModel = mongo.client.model 'Cache', CacheEntry

CacheEntry.plugin(pureautoinc.plugin, {
    model: 'Cache',
    field: 'id'
});

module.exports = cacheEntryModel

