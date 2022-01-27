extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	modulate.a = 1
func _process(delta):
	modulate.a -= delta 
	position.y -= delta * 100
	position.x += rand_range(-2, 2) * delta * 100
