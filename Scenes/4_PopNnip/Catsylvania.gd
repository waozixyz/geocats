extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _process(delta):
	
	if int(floor(OS.get_ticks_msec() * 0.0007)) % 2 == 0:
		visible = true
	else:
		visible = false


