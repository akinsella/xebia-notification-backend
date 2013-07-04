underscore = require 'underscore'
_ = underscore._

if !config
	localConfig =
		hostname: 'localhost',
		port: 9090,
		appname: 'xebia-notification-backend',
		uri: ['xebia-notification-backend.helyx.org'],
		mongo:
			dbname: 'xebia-notification-backend'
			hostname: 'localhost',
			port: 27017,
	#		username: 'xebia-notification-backend'
	#		password: 'Password123'

	config = _.extend({}, localConfig)

module.exports =
	hostname: config.hostname,
	port: config.port,
	appname: config.appname,
	uri: config.uri,
	mongo: config.mongo


