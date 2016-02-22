fs = require('fs')
  
module.exports.bootstrap = (cb) ->

	dir = './conf.d'
	if !fs.existsSync(dir)
		fs.mkdirSync dir
    	
	cb()
	return  