extends Camera2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var shake : int = 0
var shake_direction : int = 1
func _process(delta):
	if shake > 0:
		shake_direction *= -1
		offset.x += 5 * shake_direction
		shake -= delta
