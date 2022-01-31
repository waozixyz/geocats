extends BasePlayerState

export var climb_speed : float = 200

func enter_logic(player: KinematicBody2D):
	player.coll_default.disabled = true
	player.coll_climb.disabled = false
	player.tween_to_ladder()
	.enter_logic(player)
	player.play("climb")
	player.vx = 0
	player.isDoubleJumped = false

func logic(player: KinematicBody2D, _delta: float):
	if not player.on_ladder:
		return "fall"
	if player.is_on_floor():
		return "idle"
	if player.ladder_rot != 0:
		var diff_y = player.position.y / player.ladder_y
		player.position.x = player.ladder_x - 25 *  (diff_y - 1) * player.ladder_rot

	if player.underwater:
		player.vy = player.vertical * climb_speed / 2
	else:
		player.vy = player.vertical * climb_speed 
	#player.move_vertically()

	if player.jumping:
		return "jump"
	


	if player.horizontal != 0 and player.vertical == 0:
		return "fall"


func exit_logic(player: KinematicBody2D):
	.exit_logic(player)

	player.coll_default.disabled = false
	player.coll_climb.disabled = true
