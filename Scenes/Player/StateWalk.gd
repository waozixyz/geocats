extends BasePlayerState


func logic(player: KinematicBody2D, delta: float):
	player.play("walk")
	player.move_horizontally(0)

	if !player.grounded:
		return "fall"
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

	if player.jumping:
		return "jump"
	if player.horizontal == 0:
		return "idle"


