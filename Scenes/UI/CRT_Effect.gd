extends CanvasLayer

onready var crt = $ColorRect
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var org_noise = 0.05

# Called when the node enters the scene tree for the first time.
func _process(_delta):
	var hp = global.data.player_hp / 100
	var noise = (1 - hp) * .5 + org_noise
	if global.crt_noise != noise:
		global.crt_noise = (global.crt_noise * 3 + noise) / 4
	crt.material.set_shader_param("static_noise_intensity", global.crt_noise)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
