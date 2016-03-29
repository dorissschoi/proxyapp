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
		fs.writeFileSync FilePath, filedata 
		
	deleteConfig: (data) ->
		FilePath = genFileName(data.path)
		sails.log.info "Del file, path: #{FilePath} ,server: #{data.servername} ,port: #{data.port}" 
		try
			fs.accessSync FilePath
			fs.unlinkSync FilePath 	
		catch err
			sails.log.info "Del file fail : #{FilePath} err: #{err}"
			
	restartServer: (apps) ->
		sails.log.info "App:#{apps} updated - Restart Nginx..."
		child_process.exec 'killall -HUP Nginx', (error, stdout, stderr) ->
		#child_process.exec 'killall -HUP chromium', (error, stdout, stderr) ->
			if error
				sails.log.error "Restart Nginx error: #{error}"
			else
				sails.log.info "Restart Nginx completed #{stdout}"	
			return
				