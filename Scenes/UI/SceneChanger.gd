extends CanvasLayer

onready var sprite = $AnimatedSprite
onready var container = $Container
onready var MusicPlayer = $AudioStreamPlayer
onready var pause = $Pause


var location : int
var level_path: String
var timer : int
var load_time : int = 80
var change : bool

func _ready():
	sprite.modulate.a = 0
	container.modulate.a = 0

func change_scene(lvl_path):
	get_tree().paused = true
	level_path = lvl_path
	utils.tween_fade(sprite, 0, 1)
	utils.tween_fade(container, 0, 1)
	change = true
	timer = 0
	sprite.play()


func _physics_process(delta):
	var dfps = delta * global.fps
		
	if change:
		timer += dfps
		if timer > load_time:
			_new_scene()
			change = false
	
func _new_scene():
	print(level_path)
	var _err = get_tree().change_scene(level_path)
	#assert(err == OK)
	get_tree().paused = false
	
	utils.tween_fade(sprite, 1, 0)
	utils.tween_fade(container, 1, 0)
	sprite.stop()


