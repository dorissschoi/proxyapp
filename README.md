# proxyapp
Generate proxy server configure file at conf.d folder and create record in mongodb.

output file, input param: path:p, servername: localhost, port: 3002
```
location /p/ {
  proxy_pass http://localhost2:3002/;
}
```

# API
```
get /api/apps - list login user record
post /api/apps - create a apps proxy with the specified attributes
put /api/apps/:id - update a apps attributes of the specified id
delete /api/apps/:id - delete apps of the specified id
```
# Configuration

```
git clone https://github.com/dorissschoi/proxyapp.git
cd proxyapp
npm install && bower install
mkdir conf.d
```
update environment variables in config/env/development.coffee for server
```
	port:			1337
	connections:
		mongo:
			adapter:	'sails-mongo'
			driver:		'mongodb'
			host:		'localhost'
			port:		27017
			user:		'proxyapprw'
			password:	'pass1234'
			database:	'proxyapp'
```
```
node_modules/.bin/gulp
sails lift --dev
```


