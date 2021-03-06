mongo = require '../lib/mongo'
pureautoinc  = require('mongoose-pureautoinc');

User = new mongo.Schema(
	id: Number,
	email: { type: String, "default": '', trim: true },
	password: { type: String, "default": '', trim: true },
	firstName: { type: String, "default": '', trim: true },
	lastName: { type: String, "default": '', trim: true },
	googleId: { type: String, "default": '', trim: true },
	createAt: { type: Date, "default": Date.now },
	lastModified: { type: Date, "default": Date.now }
)

userModel = mongo.client.model 'User', User

User.plugin(pureautoinc.plugin, {
    model: 'User',
    field: 'id'
});

module.exports = userModel

