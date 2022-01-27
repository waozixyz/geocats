extends CanvasLayer


# get a requested scene for scene changer
const levels_path = "res://Scenes/Levels/"
const levels = {
	"TitleScreen": {
		"path": levels_path + "TitleScreen/TitleScreen.tscn",
	},
}
onready var chat_with = $ChatWith
onready var sprite = $AnimatedSprite
onready var container = $Container
onready var MusicPlayer = $AudioStreamPlayer
onready var pause = $Pause
onready var tween = $Tween

var location : int
var scene_name : String 
var timer : int
var load_time : int = 40
var change : bool

func _ready():
	sprite.modulate.a = 0
	container.modulate.a = 0


func change_scene(new_scene, location = 0, sound = "", volume = 1):
	get_tree().paused = true
	scene_name = new_scene
	Global.user.location = location
	
	change = true
	Utils.tween_fade(sprite, 0, 1)
	Utils.tween_fade(container, 0, 1)

func _physics_process(delta):
	var dfps = delta * Global.fps
		
	if change:
		timer += dfps
		if timer  > load_time:
			_new_scene()
			
	# check master volume
	var i = AudioServer.get_bus_index("Master")
	var volume = AudioServer.get_bus_volume_db(i)
	if floor(Global.user.hp) <= 0.0:
		chat_with.start("feline_emergency_teleport")
		chat_with.visible = true
		get_tree().paused = true
		# lower volume
		if volume > -80:
			AudioServer.set_bus_volume_db(i, volume - .5)
	else:
		chat_with.visible = false
		if volume < 0:
			AudioServer.set_bus_volume_db(i, volume + .5)

	
func _new_scene():
	timer = 0
	var err = get_tree().change_scene(levels[scene_name].path)
	assert(err == OK)
	get_tree().paused = false
	
	Utils.tween_fade(sprite, 1, 0, .2)
	Utils.tween_fade(container, 1, 0)
	change = false


