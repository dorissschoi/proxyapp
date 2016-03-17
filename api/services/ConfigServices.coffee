fs = require 'fs'

genFileName = (appsName) ->
	filename =	appsName + sails.config.proxy.file.extension
	filepath = 	sails.config.proxy.file.path
	return filepath + filename

module.exports = 
	createConfig: (data) ->
		FullFileName = genFileName(data.path)
		sails.log.info "Create file, path: #{FullFileName} ,server: #{data.servername} ,port: #{data.port}" 
		filedata = sails.config.proxy.file.content1 + data.path + sails.config.proxy.file.content2 + data.servername + ":" + data.port + sails.config.proxy.file.content3
		fs.writeFileSync FullFileName, filedata 
		
	deleteConfig: (data) ->
		FullFileName = genFileName(data.path)
		sails.log.info "Del file, path: #{FullFileName} ,server: #{data.servername} ,port: #{data.port}" 
		fs.unlinkSync(FullFileName)
		