extends Control

onready var music = $Music
onready var music_slider = $Music/HSlider
onready var sound = $Sound
onready var sound_slider = $Sound/HSlider

var music_bus = AudioServer.get_bus_index("Music")
var sound_bus = AudioServer.get_bus_index("Sound")



# connect functions
func _music_slider_moved(value):
	_change_volume("Music", value)

func _sound_slider_moved(value):
	_change_volume("Sound", value)
	
# Called when the node enters the scene tree for the first time.
func _ready():
	sound_slider.value = db2linear(global.data.sound)
	music_slider.value = db2linear(global.data.music)
	music_slider.connect("value_changed", self, "_music_slider_moved")
	sound_slider.connect("value_changed", self, "_sound_slider_moved")

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
func _process(delta):
	_check_mute(music)
	_check_mute(sound)
