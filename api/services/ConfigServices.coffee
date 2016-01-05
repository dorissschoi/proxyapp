fs = require 'fs'

genFileName = (appsName) ->
	filename =	appsName + sails.config.proxy.file.extension
	filepath = 	sails.config.proxy.file.path
	return filepath + filename

delFile = (data) ->
	sails.log.info "Del file, path: " + data.path + " ,server: " + data.servername + " ,port: " + data.port
	return new Promise (fulfill, reject) ->
		FullFileName = genFileName(data.path)
		fs.exists FullFileName, (exists) ->
			if exists
				fs.unlink FullFileName, (err) ->
					if err
						reject "Del file err:" + err
					else
						sails.log.info "Del file success"
						fulfill data						
			else
				reject "File not exists!"
						
createFile = (data) ->
	sails.log.info "Create file, path: " + data.path + " ,server: " + data.servername + " ,port: " + data.port
	FullFileName = genFileName(data.path)
	filedata = "location /" + data.path + "/ {\n" + "  proxy_pass http://" + data.servername + ":" + data.port + "/;\n}\n"
	
	fs.writeFile FullFileName, filedata, (err) ->
		if err
			sails.log.error "Create file err:" + err
		else
			sails.log.info "Create file success: " + FullFileName	
					
module.exports = 
	createConfig: (data) ->
		createFile(data)
		return
		
	deleteConfig: (d) ->
		if _.isUndefined(d.path)
			data = d[0]
		else
			data = d
			
		fulfill = (data) ->
			#sails.log.info "Del file success, path: " + data.path + " ,server: " + data.servername + " ,port: " + data.port
		reject = (err) ->
			sails.log.error "Del file err : " + err
		delFile(data).then fulfill, reject
		