extends BasePlayerState

#idle
var idleDurration = 3800  #how long cat should be idle until it blinks
var blinkDurration = 100 # how long cat should be in the blink anim
var idleStartTime = 0#how many miliseconds passed when you become idle
var elapsedIdleTime = 0 #how many milisecconds elapsed since you started being idle

func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	idleStartTime = OS.get_ticks_msec() #set dash start time to total ticks since the game started

func logic(player: KinematicBody2D, _delta: float):
	if player.grounded:
		player.isDoubleJumped = false
		
	if player.currentSpeed > 0:
		player.currentSpeed -= player.decceleration
		if player.currentSpeed < 0:
			player.currentSpeed = 0
	elapsedIdleTime = OS.get_ticks_msec() - idleStartTime #set elapsed idle time

	if player.on_ladder and player.vertical != 0:
		if player.allow_fall_through:
			player.fall_through()
			return "climb"
		elif player.vertical < 0:
			return "climb"
	if player.vertical > 0:
		player.play("crouch")
		if player.jumping and player.allow_fall_through:
			player.fall_through()
			return "fall"
	elif player.vertical < 0:
		player.play("slide_wall")
	else:
		player.coll_default.disabled = false
		player.coll_slide.disabled = true
		if elapsedIdleTime > idleDurration:
			player.play("blink")
			if elapsedIdleTime - idleDurration > blinkDurration:
				idleStartTime = OS.get_ticks_msec()
		else:
			player.play("idle")

	if player.underwater.size() > 0:
		return "swim"
	if not player.grounded:
		return "fall"
	if player.jumping:
		return "jump"
	if player.horizontal != 0:
		return "walk"
	


	return null
