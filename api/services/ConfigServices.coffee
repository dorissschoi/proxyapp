fs = require 'fs'

genFileName = (appsName) ->
	filename =	"#{appsName}#{sails.config.proxy.file.extension}"
	filepath = 	sails.config.proxy.file.path
	return filepath + filename

module.exports = 
	createConfig: (data) ->
		FilePath = genFileName(data.path)
		sails.log.info "Create file, path: #{FilePath} ,server: #{data.servername} ,port: #{data.port}" 
		filedata = "#{sails.config.proxy.file.content1}#{data.path}#{sails.config.proxy.file.content2}#{data.servername}:#{data.port}#{sails.config.proxy.file.content3}"
		fs.writeFileSync FilePath, filedata 
		
	deleteConfig: (data) ->
		FilePath = genFileName(data.path)
		sails.log.info "Del file, path: #{FilePath} ,server: #{data.servername} ,port: #{data.port}" 
		try
			fs.accessSync FilePath
			fs.unlinkSync FilePath 	
		catch err
			sails.log.info "Del file fail : #{FilePath} err: #{err}"