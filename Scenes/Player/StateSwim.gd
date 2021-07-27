extends BasePlayerState

export var swim_speed : float = 150
export var gravity : float = 10
export var anim_speed : float = 1.5
var original_anim_speed : float

func enter_logic(player: KinematicBody2D):
	player.velocity *= 0.5

func logic(player: KinematicBody2D, delta: float):
	if player.on_ladder and player.vertical != 0:
		return "climb"
	player.vx = player.horizontal * swim_speed
	player.apply_gravity(gravity)
	if player.jumping:
		return "jump"
	if player.underwater:
		if player.horizontal != 0:
			player.waves.emitting = true

		else:
			player.waves.emitting = false
			player.play("idle")
		player.move()
		return null
	player.waves.emitting = false
	if player.grounded:
		player.move()
		return "walk" if player.horizontal != 0 else "idle"
	player.vy = -5*swim_speed
	player.move()
	return "fall"

func exit_logic(player: KinematicBody2D):
	player.waves.emitting = false
