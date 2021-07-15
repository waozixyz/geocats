extends CanvasLayer

onready var Animation = $ViewportContainer/Viewport/AnimationPlayer
onready var Sprite = $ViewportContainer/Viewport/AnimatedSprite
onready var MusicPlayer = $AudioStreamPlayer2D

var scene : String
var timer : int
var load_time : int 
var change : bool
func _ready():
	timer = OS.get_ticks_msec() * 0.01
	
func change_scene(new_scene):
	MasterAudio.stream_paused = false
	get_tree().paused = true
	scene = new_scene
	load_time = timer + 10
	change = true
	Sprite.visible = true

func _physics_process(delta):
	timer = OS.get_ticks_msec() * 0.01
	if change:
		if timer  > load_time:
			_new_scene()
	
func _new_scene():
	Sprite.visible = false
	get_tree().change_scene(scene)
	get_tree().paused = false
	change = false

	MasterAudio.stream = null


