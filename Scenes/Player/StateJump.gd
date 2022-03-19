extends BasePlayerState



func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	var jump_height = player.jump_height
	if player.underwater:
		jump_height *= .9
	player.jump(jump_height)

func logic(player: KinematicBody2D, _delta: float):
	player.default_anim()
	if player.check_wall_slide():
		return "wall_slide"
	if player.on_ladder and player.vx == 0 and player.vertical != 0:
		return "climb"
	if player.underwater:
		return "swim"
	
	if player.isJumpPressed && !player.isDoubleJumped:
		return "double_jump" #set state to double jump
	
	if player.vy < 0:
		if player.is_on_ceiling():
			#if you hit a ceiling
			return "fall" #start falling
	else:
		return "fall"
	
	if player.grounded:
		return "walk"
	return null
