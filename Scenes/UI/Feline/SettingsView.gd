extends Control

onready var music = $Music
onready var music_slider = $Music/HSlider
onready var sound = $Sound
onready var sound_slider = $Sound/HSlider
onready var reset = $Reset

var music_bus = AudioServer.get_bus_index("Music")
var sound_bus = AudioServer.get_bus_index("Sound")

# connect functions
func _music_slider_moved(value):
	_change_volume("Music", value)

func _sound_slider_moved(value):
	_change_volume("Sound", value)

func _reset_pressed():
	global.init_data()
	SceneChanger.change_scene("TitleScreen")
	var dir = Directory.new()
	dir.remove(global.user_file)
	dir.remove(global.data_file)
# Called when the node enters the scene tree for the first time.
func _ready():
	sound_slider.value = db2linear(global.data.sound) * 100
	music_slider.value = db2linear(global.data.music) * 100
	music_slider.connect("value_changed", self, "_music_slider_moved")
	sound_slider.connect("value_changed", self, "_sound_slider_moved")
	reset.connect("pressed", self, "_reset_pressed")
func _change_volume(bus_name, slider_value):
	var db = linear2db(slider_value * 0.01)
	global.data[bus_name.to_lower()] = db
	var i = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(i, db)
	_toggle_mute(bus_name, true)
	if bus_name == "Sound":
		sound.pressed = false
	elif bus_name == "Music":
		music.pressed = false

func _toggle_mute(bus_name, forced = false):
	var i = AudioServer.get_bus_index(bus_name)
	# toggle mute
	var mute = true if not AudioServer.is_bus_mute(i) or forced else false
	AudioServer.set_bus_mute(i, mute)

	# update global for saving and loading
	global.data["no" + bus_name.to_lower()] = mute

func _check_mute(btn):
	var mute = btn.pressed
	var i = AudioServer.get_bus_index(btn.name)
	AudioServer.set_bus_mute(i, mute)
	global.data["no" + btn.name.to_lower()] = mute

func _process(_delta):
	_check_mute(music)
	_check_mute(sound)
