extends BasePlayerState



func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	player.jump(player.jump_height)

func logic(player: KinematicBody2D, _delta: float):
	player.default_anim()
	player.move_horizontally(player.airFriction) #move horizontally
	if player.check_wall_slide(player.left_raycast, -1) or player.check_wall_slide(player.right_raycast, 1):
		return "wall_slide"
	if player.on_ladder and player.vertical != 0:
		return "climb"
	if player.underwater:
		return "swim"

	if player.vy < 0:
		if player.isJumpPressed && !player.isDoubleJumped:
			return "double_jump" #set state to double jump
		if player.is_on_ceiling():
			#if you hit a ceiling
			return "fall" #start falling
	else:
		return "fall"
	
	if player.grounded:
		return "walk"
	return null
