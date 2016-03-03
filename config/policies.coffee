
module.exports = 
	policies:
		AppsController:
			'*':		false
			find:		['isAuth', 'resolveMe']
			create:		['isAuth', 'setCreatedBy']
			update:		['isAuth', 'isCreatedBy']
			destroy:	['isAuth', 'isCreatedBy']