extends BasePlayerState


func logic(player: KinematicBody2D, _delta: float):
	if player.grounded:
		player.isDoubleJumped = false
	else:
		return "fall"
	if player.vertical > 0:
		player.play("crouch")
		if player.jumping and player.current_platforms:
			player.fall_through()
			return "fall"
	elif player.vertical < 0:
		player.play("slide_wall")
	else:
		player.play("walk")

	if player.underwater.size() > 0:
		player.land_water_sfx.play()
		return "swim"
	if not player.is_on_floor():
		return "air"

	if player.jumping:
		return "jump"
	if player.horizontal == 0:
		return "idle"

