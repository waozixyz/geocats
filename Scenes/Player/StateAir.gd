extends BasePlayerState

var jumpBufferStartTime  = 0 #ticks when you ran of the platform
var elapsedJumpBuffer = 0 #how many seconds passed in the jump nuffer
var jumpBuffer = 100 #how many miliseconds allowance you give jumps after you run of an edge
func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	jumpBufferStartTime = OS.get_ticks_msec()	

func logic(player: KinematicBody2D, delta: float):
	if player.check_wall_slide(player.left_raycast, -1) or player.check_wall_slide(player.right_raycast, 1):
		return "wall_slide"

	
	if player.on_ladder and player.vertical != 0:
		return "climb"
	if player.underwater:
		return "swim"
	if player.is_on_floor():
		player.isDoubleJumped = false #reset is double jumped
		return "idle" if player.horizontal == 0 else "walk"
	if player.grounded and player.jumping and not player.sprite.animation == "crouch":
		return "jump"

	elapsedJumpBuffer = OS.get_ticks_msec() - jumpBufferStartTime #set elapsed time for jump buffer
		
	if player.isJumpPressed:
		#if you press jump
		if !player.isDoubleJumped && elapsedJumpBuffer > jumpBuffer:
			return "double_jump"

		if elapsedJumpBuffer < jumpBuffer:
			#if your in the jump buffer window
			if player.previous_state == "run":
				return "jump" #set state to jump
			if player.previous_state == "wall_slide":
				return "wall_jump"

	player.default_anim()
	player.move_horizontally(player.airFriction) #move horizontally
func exit_logic(player: KinematicBody2D):
	jumpBufferStartTime = 0 #reset jump buffer start time
