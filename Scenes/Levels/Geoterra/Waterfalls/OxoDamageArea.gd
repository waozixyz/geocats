extends AreaInteract

onready var player = get_tree().get_current_scene().player

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var dmg = 0.5
func _process(delta):
	var dfps = delta * global.fps
	if touching:
		player.damage(dmg * dfps)
