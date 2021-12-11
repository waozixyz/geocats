extends BasePlayerState

export var wall_slide_speed : float = 20

func enter_logic(player: KinematicBody2D):
	.enter_logic(player)
	player.play("slide_wall")
	player.coll_default.disabled = true
	player.coll_slide.disabled = false
	var coll_x = player.coll_slide.position.x
	if (player.sprite.flip_h and coll_x > 0) or (not player.sprite.flip_h and coll_x < 0):
		player.coll_slide.position.x *= -1
	player.sprite.position = Vector2(0, 0)
func logic(player: KinematicBody2D, _delta: float):
	player.vy = (player.vy + wall_slide_speed * 3) / 4 ##override apply_gravity and apply a constant slide speed
	if player.jumping and not player.is_on_ceiling():
		if player.check_wall_slide(player.left_raycast, -1) or player.check_wall_slide(player.right_raycast, 1):
			player.vy -= 300
			return "wall_slide"
		else:
			return "jump"
	else:
		if player.check_wall_slide(player.left_raycast, -1) or player.check_wall_slide(player.right_raycast, 1):
			return "wall_slide"
		else:
			return "fall"
func exit_logic(player: KinematicBody2D):
	.exit_logic(player)

	player.isDoubleJumped = false
	player.coll_default.disabled = false
	player.coll_slide.disabled = true
