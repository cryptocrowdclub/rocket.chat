config =
	serverURL: ''
	authorizePath: '/m/oauth2/auth/'
	tokenPath: '/m/oauth2/token/'
	identityPath: '/m/oauth2/api/me/'
	addAutopublishFields:
		forLoggedInUser: ['services.trident']
		forOtherUsers: ['services.trident.name']

Trident = new CustomOAuth 'trident', config

# class TridentOnCreateUser
#	constructor: (options, user) ->
#		if user.services?.trident?.name?
#			user.username = user.services.trident.name
#		return user

if Meteor.isServer
	Meteor.startup ->
		RocketChat.models.Settings.find({ _id: 'API_Trident_URL' }).observe
			added: (record) ->
				config.serverURL = RocketChat.settings.get 'API_Trident_URL'
				Trident.configure config
			changed: (record) ->
				config.serverURL = RocketChat.settings.get 'API_Trident_URL'
				Trident.configure config

	# RocketChat.callbacks.add 'beforeCreateUser', TridentOnCreateUser, RocketChat.callbacks.priority.HIGH
else
	Meteor.startup ->
		Tracker.autorun ->
			if RocketChat.settings.get 'API_Trident_URL'
				config.serverURL = RocketChat.settings.get 'API_Trident_URL'
				Trident.configure config