extends Particles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var substance = "water"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	var mat = process_material
	if substance == "water":
		mat.color = Color(0.6, 0.823, 0.87, 1)
	elif substance == "slime":
		mat.color = Color(0.7, 0.8, 0.5, 1)

