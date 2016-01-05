
module.exports = 
	policies:
		TodoController:
			'*':	false
			find:	['isAuth', 'todo/setTask']	
			create: ['isAuth', 'setCreatedBy' , 'setOwner']
			update: ['isAuth', 'isOwnerOrCreatedBy']
			destroy: ['isAuth', 'isCreatedBy']
		AppsController:
			'*':		false
			find:		['isAuth', 'filterByCreatedBy']
			findOne:	['isAuth', 'filterByCreatedBy']
			create:		['isAuth', 'setCreatedBy']
			update:		['isAuth', 'isCreatedBy']
			destroy:	['isAuth', 'isCreatedBy']