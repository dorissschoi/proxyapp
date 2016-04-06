fs = require 'fs'
child_process = require('child_process')

genFileName = (appsName) ->
	filename =	"#{appsName}#{sails.config.proxy.file.extension}"
	filepath = 	sails.config.proxy.file.path
	return filepath + filename

module.exports = 
	createConfig: (data) ->
		FilePath = genFileName(data.path)
		sails.log.info "Create file, path: #{FilePath} ,server: #{data.servername} ,port: #{data.port}" 
		filedata = "#{sails.config.proxy.file.content1}#{data.path}#{sails.config.proxy.file.content2}#{data.servername}:#{data.port}#{sails.config.proxy.file.content3}"
		try
			fs.writeFileSync FilePath, filedata
		catch err
			sails.log.error "Create file fail : #{data.path} err: #{err}"
			return
		return
					
	deleteConfig: (data) ->
		FilePath = genFileName(data.path)
		sails.log.info "Del file, path: #{FilePath} ,server: #{data.servername} ,port: #{data.port}" 
		try
			fs.accessSync FilePath
			fs.unlinkSync FilePath 	
		catch err
			sails.log.error "Del file fail : #{FilePath} err: #{err}"
			return
		return
		
	restartServer: (apps) ->
		sails.log.info "App:#{apps} reload Nginx configure"
		try
			child_process.execSync "#{sails.config.proxy.nginx.reload}"
		catch err
			sails.log.error "Reload Nginx configure fail : #{apps} err: #{err}"
			return
		return	
				