extends BasePlayerState

export var climb_speed : float = 200

func enter_logic(player: KinematicBody2D):
	player.coll_default.disabled = true
	player.coll_climb.disabled = false
	player.tween_to_ladder()
	.enter_logic(player)
	player.play("climb")
	player.vx = 0

func logic(player: KinematicBody2D, delta: float):
	if player.ladder_rot != 0:
		var diff_y = player.position.y / player.ladder_y
		player.position.x = player.ladder_x - 25 *  (diff_y - 1) * player.ladder_rot

	if player.underwater:
		player.vy = player.vertical * climb_speed / 2
	else:
		player.vy = player.vertical * climb_speed 
	#player.move_vertically()

	if player.jumping:
		return "fall"
	
	if not player.on_ladder or player.is_on_floor():
		player.vy *= .5
		return "fall"

	if player.horizontal != 0 and player.vertical == 0:
		return "fall"


func exit_logic(player: KinematicBody2D):
	.exit_logic(player)

	player.coll_default.disabled = false
	player.coll_climb.disabled = true
