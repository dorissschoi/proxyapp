# add criteria for proxy app and current login user  
module.exports = (req, res, next) ->
	req.options.where = req.options.where || {}
	_.extend req.options.where, createdBy: req.user.username	
	next()