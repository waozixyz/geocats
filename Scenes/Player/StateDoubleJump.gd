extends BasePlayerState

export var jump_speed : float = 1000

func enter_logic(player: KinematicBody2D):
	player.isDoubleJumped = true #make sure you can only double jump once
	
func logic(player: KinematicBody2D, delta: float):
	if player.vx == 0:
		player.play("idle")
	else:
		player.play("walk")
	player.vy = -jump_speed
	player.move()
	if player.on_ladder and player.vertical != 0:
		return "climb"
	if player.underwater:
		return "swim"
	return "fall"
