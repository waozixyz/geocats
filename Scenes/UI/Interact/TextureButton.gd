extends TextureButton

export(String, FILE, "*.ogg, *.wav") var sound_file = ""
export(float, 0, 100) var sound_volume = 100
func _ready():
	var err = connect("pressed", self, "_button_pressed")
	assert(err == OK)
	
func _button_pressed():
	AudioManager.play_sound(sound_file, sound_volume)
