extends Node2D


onready var shrink = ProjectSettings.get_setting("display/window/stretch/shrink")
func _init():
	ProjectSettings.set_setting("display/window/stretch/shrink", 10)

	print(ProjectSettings.get_setting("display/window/stretch/shrink"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
