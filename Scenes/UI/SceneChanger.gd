extends CanvasLayer

const levels_path = "res://Scenes/Levels"

onready var chat_with = $ChatWith
onready var sprite = $AnimatedSprite
onready var container = $Container
onready var MusicPlayer = $AudioStreamPlayer
onready var pause = $Pause
onready var tween = $Tween

var location : int
var level_name : String
var level_territory : String
var level_parent : String
var timer : int
var load_time : int = 80
var change : bool

func _ready():
	sprite.modulate.a = 0
	container.modulate.a = 0

func change_scene(lvl_name, lvl_territory = "", lvl_location = 0, lvl_parent = null):
	get_tree().paused = true
	level_name = lvl_name
	level_territory = lvl_territory
	level_parent = lvl_parent if lvl_parent else lvl_name
	Global.user.location = lvl_location
	Utils.tween_fade(sprite, 0, 1)
	Utils.tween_fade(container, 0, 1)
	change = true
	timer = 0
	sprite.play()

func _get_scene_path():
	return levels_path + "/" + level_territory + "/" + level_parent + "/" + level_name + ".tscn"

func _physics_process(delta):
	var dfps = delta * Global.FPS
		
	if change:
		timer += dfps
		if timer > load_time:
			_new_scene()
			change = false
	
func _new_scene():
	var err = get_tree().change_scene(_get_scene_path())
	assert(err == OK)
	get_tree().paused = false
	
	Utils.tween_fade(sprite, 1, 0)
	Utils.tween_fade(container, 1, 0)
	sprite.stop()


