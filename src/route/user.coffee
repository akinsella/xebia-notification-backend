utils = require '../lib/utils'
_ = require('underscore')._
apn = require 'apn'
User = require "../model/user"

create = (req, res) ->
	user = new User(req.body)
	user.save (err) ->
		if (err)
			utils.responseData(500, "Could not save user", req.body, { req:req, res:res})
		else
			utils.responseData(201, "Created", user, { req:req, res:res})
		return

list = (req, res) ->
	User.find {}, (err, users) ->
		utils.responseData(200, undefined, users, { req:req, res:res })
		return

findById = (req, res) ->
	User.findOne { id: req.params.id }, (err, user) ->
		if (user)
			utils.responseData(200, undefined, user, { req:req, res:res })
		else
			utils.responseData(404, "Not Found", undefined, { req:req, res:res })
		return

removeById = (req, res) ->
	User.findOneAndRemove { id: req.params.id }, (err, user) ->
		if (user)
			utils.responseData(204, undefined, user, { req:req, res:res })
		else
			utils.responseData(404, "Not Found", undefined, { req:req, res:res })
		return

me = (req, res) ->
	  # req.authInfo is set using the `info` argument supplied by
	  # `BearerStrategy`.  It is typically used to indicate scope of the token,
	  # and used in access control checks.  For illustrative purposes, this
	  # example simply returns the scope in the response.
	  res.json
	    user_id: req.user.id
	    name: req.user.name
	    scope: req.authInfo.scope

module.exports =
	create : create,
	list : list,
	findById : findById,
	create : create,
	removeById : removeById,
	me: me
