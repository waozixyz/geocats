extends BasePlayerState


func logic(player: KinematicBody2D, delta: float):
	if player.vertical > 0:
		player.collision_layer = 1
		player.platform_timer.start()

	player.play("walk")
	if player.vertical > 0:
		player.play("crouch")
		if player.jumping and player.current_platforms:
			player.fall_through()
			return "fall"


	if player.on_ladder and player.vertical != 0:
		return "climb"
	if player.underwater:
		return "swim"
	if not player.is_on_floor():
		return "air"
	if player.vy > 0:
		player.vy = 0
	if player.jumping:
		return "jump"
	if player.horizontal == 0:
		return "idle"
	else:
		#if pressing move button start moving
		player.move_horizontally(0)
	return null
