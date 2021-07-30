extends BasePlayerState

export var gravity : float = 10
export var anim_speed : float = 1.5
var original_anim_speed : float
var water_friction : float = 150
func enter_logic(player: KinematicBody2D):
	player.velocity *= 0.5

func logic(player: KinematicBody2D, delta: float):
	if player.on_ladder and player.vertical != 0:
		return "climb"

	player.apply_gravity(gravity)
	player.move_horizontally(water_friction) #move horizontally
	if player.jumping:
		return "jump"
	if player.underwater:
		if player.horizontal != 0:
			player.waves.emitting = true

		else:
			player.waves.emitting = false
			player.play("idle")

		return null
	player.waves.emitting = false
	if player.grounded:
		return "walk" if player.horizontal != 0 else "idle"

	return "fall"

func exit_logic(player: KinematicBody2D):
	player.waves.emitting = false
