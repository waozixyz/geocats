extends BasePlayerState

func enter_logic(player: KinematicBody2D):
	.enter_logic(player)


func logic(player: KinematicBody2D, _delta: float):
	if player.check_wall_slide(player.left_raycast, -1) or player.check_wall_slide(player.right_raycast, 1):
		return "wall_slide"

	if player.on_ladder and player.vertical != 0:
		return "climb"
	if player.underwater:
		player.land_water_sfx.play()
		return "swim"
	if player.is_on_floor():
		player.isDoubleJumped = false #reset is double jumped
		return "idle" if player.horizontal == 0 else "walk"

	
	if player.isJumpPressed and not player.isDoubleJumped:
		return "double_jump"
	
	player.default_anim()
	if not player.is_on_wall():
		player.move_horizontally(player.airFriction) #move horizontally
	
