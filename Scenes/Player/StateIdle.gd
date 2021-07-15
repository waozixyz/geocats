extends BasePlayerState

#idle
var idleDurration = 3800  #how long cat should be idle until it blinks
var blinkDurration = 100 # how long cat should be in the blink anim
var idleStartTime = 0#how many miliseconds passed when you become idle
var elapsedIdleTime = 0 #how many milisecconds elapsed since you started being idle

func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	player.vx = 0
	idleStartTime = OS.get_ticks_msec() #set dash start time to total ticks since the game started
		
func logic(player: KinematicBody2D, delta: float):
	elapsedIdleTime = OS.get_ticks_msec() - idleStartTime #set elapsed idle time
	if elapsedIdleTime > idleDurration:
		player.play("blink")
		if elapsedIdleTime - idleDurration > blinkDurration:
			idleStartTime = OS.get_ticks_msec()
	else:
		player.play("idle")
	if player.vertical > 0:
		player.play("crouch")
		if player.jumping and player.current_platforms:
			player.fall_through()
			return "fall"

	if player.vy > 0:
		player.vy = 0
	if player.vertical && player.on_ladder:
		if player.is_on_floor() and player.vertical < 0 and not player.current_platforms || not player.is_on_floor():
			return "climb"
		if player.current_platforms and player.vertical > 0:
			player.fall_through()
			return "climb"

	if player.underwater:
		return "swim"
	if not player.grounded:
		return "fall"
	if player.jumping:
		return "jump"
	if player.horizontal != 0:
		return "walk"
	return null
