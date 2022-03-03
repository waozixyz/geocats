extends AnimatedSprite


onready var hud = get_tree().get_current_scene().get_node("CanvasLayer/HUD/AnimatedSprite")
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if hud.frame <= 10:
		frame = hud.frame
