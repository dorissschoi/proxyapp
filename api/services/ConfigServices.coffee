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
		sails.log.info "Link file: sudo ln -s #{sails.config.proxy.source.path}/#{data.path}.conf #{sails.config.proxy.nginx.path}/#{data.path}.conf"
		try
			fs.writeFileSync FilePath, filedata
			child_process.execSync "sudo ln -s #{sails.config.proxy.source.path}/#{data.path}.conf #{sails.config.proxy.nginx.path}/#{data.path}.conf"
		catch err
			sails.log.error "Create file fail : #{data.path} err: #{err}"
			return
		return
					
	deleteConfig: (data) ->
		FilePath = genFileName(data.path)
		sails.log.info "Del file, path: #{FilePath} ,server: #{data.servername} ,port: #{data.port}" 
		sails.log.info "Del file: #{sails.config.proxy.source.path}/#{data.path}.conf #{sails.config.proxy.nginx.path}/#{data.path}.conf"
		try
			child_process.execSync "sudo rm #{sails.config.proxy.source.path}/#{data.path}.conf #{sails.config.proxy.nginx.path}/#{data.path}.conf" 	
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
				