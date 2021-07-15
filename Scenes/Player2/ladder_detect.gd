extends Area2D


func _ready():
	connect("area_entered", self, "_on_area_enter")
	connect("area_exited", self, "_on_area_exit")

func _on_area_enter(value):
	if value.is_in_group("ladder"):
		get_parent().on_ladder = true
		get_parent().ladder_x = value.position.x + 50
		
func _on_area_exit(value):
	if value.is_in_group("ladder"):
		get_parent().on_ladder = false
