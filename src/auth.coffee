passport = require 'passport'
LocalStrategy = require('passport-local').Strategy
GoogleStrategy = require('passport-google').Strategy
BasicStrategy = require('passport-http').BasicStrategy
ClientPasswordStrategy = require('passport-oauth2-client-password').Strategy
BearerStrategy = require('passport-http-bearer').Strategy
User = require './model/user'
utils = require './lib/utils'
db = require './db'

###
LocalStrategy

This strategy is used to authenticate users based on a username and password.
Anytime a request is made to authorize an application, we must ensure that
a user is logged in before asking them to approve the request.
###
passport.use new LocalStrategy((email, password, done) ->
	db.users.findByEmail email, (err, user) ->
		return done(err)  if err
		return done(null, false) unless user
		return done(null, false) unless user.password is password
		done null, user

)

# Use the GoogleStrategy within Passport.
#   Strategies in passport require a `validate` function, which accept
#   credentials (in this case, an OpenID identifier and profile), and invoke a
#   callback with a user object.
passport.use new GoogleStrategy({
		returnURL: 'http://localhost:8000/auth/google/callback',
		realm: 'http://localhost:8000/'
	}, (identifier, profile, done) =>
		# asynchronous verification, for effect...
		process.nextTick () =>

			# To keep the example simple, the user's Google profile is returned to
			# represent the logged-in user.  In a typical application, you would want
			# to associate the Google account with a user record in your database,
			# and return that user instead.
			profile.identifier = identifier
			User.findOne { email: profile.emails[0].value }, (err, user) ->
				if (err)
					done(err, null)
				else if (user)
					user.firstName = profile.name.givenName
					user.lastName = profile.name.familyName
					user.googleId = utils.getParameterByName(profile.identifier, "id")
					user.save (err) ->
						done(err, profile)
				else
					user = new User({ email:profile.emails[0].value, firstName: profile.name.givenName, lastName: profile.name.familyName, googleId:utils.getParameterByName(profile.identifier, "id") })
					user.lastName = profile.name.familyName
					user.save (err) ->
						done(err, profile)
	)

# Passport session setup.
#   To support persistent login sessions, Passport needs to be able to
#   serialize users into and deserialize users out of the session.  Typically,
#   this will be as simple as storing the user ID when serializing, and finding
#   the user by ID when deserializing.  However, since this example does not
#   have a database of user records, the complete Google profile is serialized
#   and deserialized.
passport.serializeUser (user, done) =>
	googleId = utils.getParameterByName(user.identifier, "id")
	done(null, googleId);

passport.deserializeUser (id, done) =>
	User.find {googleId: id}, (err, user) ->
		done(err, user);


###
BasicStrategy & ClientPasswordStrategy

These strategies are used to authenticate registered OAuth clients.  They are
employed to protect the `token` endpoint, which consumers use to obtain
access tokens.  The OAuth 2.0 specification suggests that clients use the
HTTP Basic scheme to authenticate.  Use of the client password strategy
allows clients to send the same credentials in the request body (as opposed
to the `Authorization` header).  While this approach is not recommended by
the specification, in practice it is quite common.
###
passport.use new BasicStrategy((username, password, done) ->
	db.clients.findByClientId username, (err, client) ->
		return done(err)  if err
		return done(null, false)  unless client
		return done(null, false)  unless client.clientSecret is password
		done null, client

)
passport.use new ClientPasswordStrategy((clientId, clientSecret, done) ->
	db.clients.findByClientId clientId, (err, client) ->
		return done(err)  if err
		return done(null, false)  unless client
		return done(null, false)  unless client.clientSecret is clientSecret
		done null, client

)

###
BearerStrategy

This strategy is used to authenticate users based on an access token (aka a
bearer token).  The user must have previously authorized a client
application, which is issued an access token to make requests on behalf of
the authorizing user.
###
passport.use new BearerStrategy((accessToken, done) ->
	db.accessTokens.find accessToken, (err, token) ->
		return done(err)  if err
		return done(null, false)  unless token
		db.users.find token.userID, (err, user) ->
			return done(err)  if err
			return done(null, false)  unless user

			# to keep this example simple, restricted scopes are not implemented,
			# and this is just for illustrative purposes
			info =
				scope: "*"
			done null, user, info


)
