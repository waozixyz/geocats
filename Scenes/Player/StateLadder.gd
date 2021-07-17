extends BasePlayerState

export var climb_speed : float = 400

func enter_logic(player: KinematicBody2D):
	player.coll_default.disabled = true
	player.coll_climb.disabled = false
	player.tween_to_ladder()
	.enter_logic(player)
	player.play("climb")


func logic(player: KinematicBody2D, delta: float):
	if player.underwater:
		player.vy = player.vertical * climb_speed / 2
	else:
		player.vy = player.vertical * climb_speed

	player.move_vertically()
	if player.jumping:
		return "jump"
	if not player.on_ladder or player.is_on_floor():
		return "fall"

	if player.horizontal != 0 and player.vertical == 0:
		return "fall"
		
	return null

func exit_logic(player: KinematicBody2D):
	.exit_logic(player)

	player.coll_default.disabled = false
	player.coll_climb.disabled = true
