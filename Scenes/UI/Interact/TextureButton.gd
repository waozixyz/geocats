extends TextureButton

export(String, FILE, "*.ogg, *.wav") var sound_file = ""
export(float) var sound_volume = 1
func _ready():
	var err = connect("pressed", self, "_button_pressed")
	assert(err == OK)
	
func _button_pressed():
	AudioManager.play_sound(sound_file, sound_volume)
