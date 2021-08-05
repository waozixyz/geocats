extends Area2D


func _ready():
	assert(connect("area_entered", self, "_on_area_enter") == 0)
	assert(connect("area_exited", self, "_on_area_exit") == 0)

func _on_area_enter(value):
	if value.is_in_group("ladder"):
		get_parent().on_ladder = true
		get_parent().ladder_x = value.position.x
		get_parent().ladder_y = value.position.y
		get_parent().ladder_rot = value.rotation_degrees
				
		
func _on_area_exit(value):
	if value.is_in_group("ladder"):
		get_parent().on_ladder = false
