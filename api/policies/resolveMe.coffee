actionUtil = require 'sails/lib/hooks/blueprints/actionUtil'

module.exports = (req, res, next) ->
	if _.isUndefined req.query.createdBy
		return next()
		
	if req.query.createdBy == 'me'
		req.query.createdBy = req.user.username
	else
		req.query.createdBy = req.query.createdBy
		
	next()		