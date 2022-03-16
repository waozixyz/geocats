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

func _get_level_path(level_territory, level_name = ""):
	if level_name.empty():
		level_name = level_territory
	var start = "res://Scenes/Levels/"
	var end = level_name + ".tscn"
	var file2Check = File.new()
	if file2Check.file_exists(start + level_territory + "/" + end):
		return start + level_territory + "/" + end
	elif file2Check.file_exists(start + level_territory + "/" + level_name + "/" + end):
		return start + level_territory + "/" + level_name + "/" + end
	else:
		printerr("wrong path: ", start, level_territory, "/", end)

func change_scene(level_territory, level_name = ""):
	get_tree().paused = true
	if global.user.visited.has(level_territory):
		global.user.visited[level_territory].append(level_name)
	else:
		global.user.visited[level_territory] = [level_name]
	
	level_path = _get_level_path(level_territory, level_name)
	if level_path:
		utils.tween(sprite, "fade", 1)
		utils.tween(container, "fade", 1)
		change = true
		timer = 0
		sprite.play()
	else:
		printerr("missing level path")


func _physics_process(delta):
	var dfps = delta * global.fps
		
	if change:
		timer += dfps
		if timer > load_time:
			_new_scene()
			change = false

func _new_scene():
	for item in AudioManager.playing.values():
		if item.sound.pause_mode != PAUSE_MODE_PROCESS:
			item.sound.stop()
			item.volume = linear2db(0)
			item.sound.playing = false

	var err = get_tree().change_scene(level_path)
	assert(err == OK)
	get_tree().paused = false
	
	utils.tween(sprite, "fade", 0)
	utils.tween(container, "fade", 0)
	sprite.stop()


