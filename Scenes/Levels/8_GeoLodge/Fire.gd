extends InteractSimple


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var sprite = $AnimatedSprite


# Called when the node enters the scene tree for the first time.
func _process(delta):
	._process(delta)
	if do_something:
		do_something = false
		sprite.visible = true
		disabled = true
