
module.exports = 
	policies:
		AppsController:
			'*':		false
			find:		['isAuth', 'filterByCreatedBy']
			findOne:	['isAuth', 'filterByCreatedBy']
			create:		['isAuth', 'setCreatedBy']
			update:		['isAuth', 'isCreatedBy']
			destroy:	['isAuth', 'isCreatedBy']