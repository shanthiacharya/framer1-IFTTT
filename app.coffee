container = new Layer
	width: 320
	height: 568
	backgroundColor: null
	originX: 0
	originY: 0
	scale: Screen.height / 568

# Page component

page = new PageComponent
	size: container.size
	parent: container
	scrollVertical: no
#Page 1	
page.addPage page_1_content

for icon in [instagram,calendar,rss_feed, soundcloud, stocks, gmail, facebook, weather]
	icon.parent = container
	

	
page.bringToFront()
instagram.bringToFront()
calendar.bringToFront()

w_x = weather.x
f_x = facebook.x
g_x = gmail.x
s_x = stocks.x
sc_x = soundcloud.x
c_x = calendar.x
i_x = instagram.x
r_x = rss_feed.x

# Page 2
page.addPage page_2_content

i_recipe_x = instagram_recipe.x
# Page 3
page.addPage page_3_content

r_arrow_x = recipe_arrows.x

# Page 4
page.addPage page_4_content

# Page 5
page.addPage page_5_content

# Page 6
page.addPage page_6_content

phone_and_trails.parent = container
ios_contacts.parent = container
ios_notif.parent = container
ios_photos.parent = container
ios_location.parent = container

phone_and_trails.saved = phone_and_trails.point
ios_contacts.saved = ios_contacts.point
ios_notif.saved = ios_notif.point
ios_photos.saved = ios_photos.point
ios_location.saved = ios_location.point

for layer in [phone_and_trails,ios_notif,ios_photos,ios_contacts,ios_location]
	layer.y += page.height

# positions of the app icons on page 5
ios_photos.p5 = 
	x:82
	y:244
ios_location.p5 = 
	x:84
	y:114
ios_contacts.p5 =
	x: 82
	y:373

# indicators
indicatorsContainer = new Layer
	width: page.width, height: 6
	backgroundColor: null
	y:551
	parent: container	
allIndicators = []

for i in [0..5]
	indicator = new Layer
		size: 6
		backgroundColor: "white"
		borderRadius: "50%"
		opacity: 0.5
		x: 119.5 + (i * 15)
		parent: indicatorsContainer
	indicator.states.active =
			opacity: 1
	indicator.animationOptions = time: 0.5	
	allIndicators.push indicator
	
allIndicators[0].stateSwitch "active"


# Page Move interactions

page.onMove ->
	weather.x       = w_x  + ( page.scrollX * 1.7 )
	rss_feed.x      = r_x  + ( page.scrollX * 0.9 )
	facebook.x      = f_x  + ( page.scrollX * 0.55 )
	gmail.x         = g_x  + ( page.scrollX * 0.4 )
	stocks.x        = s_x  + ( page.scrollX * 1.5 )
	soundcloud.x    = sc_x + page.scrollX
	instagram.x     = i_x  + ( page.scrollX * 1.5 )
	calendar.x      = c_x  + ( page.scrollX * 1.3 )
	
# from page 2 to page 3
	instagram_recipe.x = Utils.modulate page.scrollX,
		[page.width, page.width * 2], 
		[i_recipe_x, i_recipe_x + page.width], yes
		
# from page 3 to page 4
	recipe_arrows.x = Utils.modulate page.scrollX,
		[page.width * 2, page.width * 3], 
		[r_arrow_x, r_arrow_x - (page.width * 1.5)], yes

# from page 4 to page 5
	phone_and_trails.y = Utils.modulate page.scrollX,
		[page.width * 2, page.width * 3], 
		[phone_and_trails.saved.y + page.height ,phone_and_trails.saved.y],yes


	for trail in [trail_left,trail_right,trail_c_left,trail_c_right]
		trail.scaleX = Utils.modulate page.scrollX,
			[page.width * 2, page.width * 3],[0.1,1],yes 
		trail.opacity = Utils.modulate page.scrollX,
			[page.width * 2.4, page.width * 3],[0,1],yes

	for icon in [ios_photos, ios_notif, ios_location, ios_contacts]
		icon.y = Utils.modulate page.scrollX,
			[page.width * 2, page.width * 3 ],
			[icon.saved.y + page.height, icon.saved.y],yes
		icon.scale= Utils.modulate page.scrollX,
			[page.width * 2, page.width * 3 ],
			[0.50,1],yes
			
	phone_and_trails.x = Utils.modulate page.scrollX,
		[page.width *3, page.width *4],
		[0, -page.width], yes		
			
	ios_notif.opacity = Utils.modulate page.scrollX,
		[page.width*3, (page.width*3)+50],
		[1,0], yes
	ios_notif.x = Utils.modulate page.scrollX,
		[page.width *3, page.width * 4],
		[ios_notif.saved.x , ios_notif.saved.x - page.width],yes
		
	if page.scrollX >= page.width * 3	
		for icon in [ios_photos, ios_location, ios_contacts]
			icon.size = Utils.modulate page.scrollX,
				[page.width * 3, page.width *4],
				[91,40], yes
			icon.x = Utils.modulate page.scrollX,
				[page.width *3, page.width * 4],
				[icon.saved.x, icon.p5.x], yes
			icon.y = Utils.modulate page.scrollX,
				[page.width * 3, page.width *4],
				[icon.saved.y, icon.p5.y],yes
				
	if page.scrollX >= page.width * 4
		for icon in [ios_photos, ios_location,ios_contacts]
			icon.x = Utils.modulate page.scrollX,
				[page.width * 4, page.width * 5],
				[icon.p5.x, icon.p5.x - page.width], yes
				
	white_button.onTapStart ->
		this.animate
			opacity: 0.75
			options:
				time: 0.2
	white_button.onTapEnd ->
		this.animate
			opacity: 1
			options:
				time:0.2
				
	white_button.x = Utils.modulate page.scrollX, 
		[page.width * 4 , page.width * 6],
		[page.width + 25, - page.width + 25],yes
		
	banner_sign_in.x = Utils.modulate page.scrollX, 
		[page.width * 4 , page.width * 6],
		[(page.width *.5) + 25, - (page.width * .5) + 25],yes
		
	
page.on "change:currentPage", ->
	indicator.animate "default" for indicator in allIndicators
	current = page.horizontalPageIndex page.currentPage
	allIndicators[current].animate "active"
	
	indicatorsContainer.x = Utils.modulate page.scrollX,
				[page.width * 4, page.width * 5],
				[0, -page.width * 2], yes
				
# Splash Screen

Splash.point = 0
Splash.bringToFront()
Splash.ignoreEvents = no

Utils.delay 2, ->
	Splash.animate
		opacity: 0
		scale: 2
		options: 
			time: 0.5
	Splash.ignoreEvents = yes

form_fields.states =
		createAccount:
			y:0
		signIn:
			y: -45
		resetPassword:
			y: -88
form_fields.animationOptions = 
		time: 0.35
		curve: Spring(damping: 0.7)

form_fields.onTap -> 
	this.stateCycle()
	
currentMode = "createAccount"
	
switchToMode = (mode) ->
	
	if mode is "signIn"
	
		if currentMode is "resetPassword"
		# When returning from 'Reset password'
		    # Hide the Reset Password text
			placeholder_reset_password.animate
				opacity: 0
				options: 
					time: 0.25
			# Hide the small cancel test
			cancel_small.opacity = 0
			# Make Reset Password text visible again
			reset_password_small.visible = yes
			reset_password_small.y = 285
			reset_password_small.animate
				y: 338.5
				options: 
					time: 0.20
					delay: 0.25
		else
		   # When coming from Create Account
			placeholders_create_account.animate
				opacity: 0
				options: 
					time: 0.25
			
		Utils.delay 0.25, ->
			label_reset_password.visible = no
			label_create_account.visible = no
			label_sign_in.visible = yes
			banner_sign_in.visible = no
			banner_sign_up.visible = yes
			
			form_fields.animate "signIn"
		
		
		reset_password_small.animate
			opacity: 1
			options: 
				time:0.5
				delay:0.25
		placeholders_sign_in.animate
			opacity: 1
			options: 
				time: 0.25
				delay: 0.50
				
	else if mode is "createAccount"
		placeholders_sign_in.animate
			opacity: 0
			options: 
				time: 0.25
		reset_password_small.animate
			opacity: 0
			options: 
				time: 0.25
				delay:0.25
		Utils.delay 0.25, ->
			label_sign_in.visible = no
			label_create_account.visible = yes
			banner_sign_in.visible = yes
			banner_sign_up.visible = no
			
			form_fields.animate "createAccount"
			
		placeholders_create_account.animate
			opacity: 1
			options: 
				time: 0.25
				delay: 0.50
				
	else if mode is "resetPassword"
		placeholders_sign_in.animate
			opacity: 0
			options: 
				time: 0.25
		cancel_small.y = 338
		
		Utils.delay 0.25, ->
			reset_password_small.visible = no
			cancel_small.opacity = 1
			label_sign_in.visible = no
			label_reset_password.visible = yes
			banner_sign_up.visible = no
			
			form_fields.animate "resetPassword"
			
			cancel_small.animate
				y:285
				options: 
					time: 0.20
					delay: 0.25
					
			placeholder_reset_password.animate
				opacity: 1
				options: 
					time: 0.25
					delay: 0.50
		currentMode = mode	
		
banner_sign_in.onTap ->
	switchToMode "signIn"
banner_sign_up.onTap ->
	switchToMode "createAccount"
reset_password_small.onTap ->
	switchToMode "resetPassword"
cancel_small.onTap ->
	switchToMode "signIn"