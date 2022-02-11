extends Node2D

export var width = 640
export var layers = {"Small": true, "Medium": true, "Large": true }
export var preprocess = true

func _ready():
	for child in get_children():
		if child is CPUParticles2D:
			if layers[child.name]:
				child.position.x = width * .5
				child.emission_rect_extents.x = width * .5
				child.preprocess = 150 if preprocess else 0
			else:
				remove_child(child)
