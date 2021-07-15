extends CanvasLayer

onready var Animation = $ViewportContainer/Viewport/AnimationPlayer
onready var Sprite = $ViewportContainer/Viewport/AnimatedSprite
var scene : String
var timer : int
var change : bool

func change_scene(new_scene):
	get_tree().paused = true
	scene = new_scene
	timer = 700
	change = true
	Sprite.visible = true


func _physics_process(delta):
	if timer > 0:
		timer -= OS.get_ticks_msec()  * .001
	else:
		if change:
			_new_scene()

	
func _new_scene():
	Sprite.visible = false
	get_tree().change_scene(scene)
	get_tree().paused = false
	change = false




