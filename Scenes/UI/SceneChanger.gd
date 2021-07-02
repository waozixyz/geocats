extends CanvasLayer

onready var Animation = $Control/AnimationPlayer
var scene : String

func change_scene(new_scene, anim):
	scene = new_scene
	Animation.play(anim)
	
func _new_scene():
	print(scene)
	get_tree().change_scene(scene)




