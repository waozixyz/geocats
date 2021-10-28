extends InteractSimple


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _process(delta):
	if do_something:
		get_parent().creppy_city()
		do_something  = false
		disabled = true
