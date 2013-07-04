underscore = require 'underscore'
_ = underscore._

if !config
	localConfig =
		hostname: 'localhost',
		port: 8000,
		name: 'xebia-mobile-backend',
		uri: ['xebia-notification-backend.helyx.org'],
		mongoConfig:
			name: 'xebia-notification-backend-mongodb',
			credentials:
			hostname: 'localhost',
			port: 27017,
	#		username: 'xebia-mobile-backend'
	#		password: 'Password123'

	config = _.extend({}, localConfig)

module.exports =
	confif: config

