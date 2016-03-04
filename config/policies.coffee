
module.exports = 
	policies:
		AppsController:
			'*':		false
			find:		['isAuth', 'resolveMe']
			findOne:	['isAuth']		
			create:		['isAuth', 'setCreatedBy']
			update:		['isAuth', 'isCreatedBy']
			destroy:	['isAuth', 'isCreatedBy']