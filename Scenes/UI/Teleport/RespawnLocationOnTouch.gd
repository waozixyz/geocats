extends AreaInteract
class_name RespawnLocationOnTouch

onready var current_scene = get_tree().get_current_scene()

# Called when the node enters the scene tree for the first time.
func _process(delta):
	if touching:
		current_scene.respawn_location = position
