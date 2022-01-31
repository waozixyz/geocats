extends Node

func _finished_playing(sound):
	remove_child(sound)

func play_sound(sound_file):
	if sound_file:
		var sound = AudioStreamPlayer.new()

		sound.stream = load(sound_file)

		if sound.stream is AudioStreamOGGVorbis:
			sound.stream.loop = false
		
		sound.bus = "Sound"
		sound.connect("finished", self, "_finished_playing", [sound])
		sound.play()

		add_child(sound)
