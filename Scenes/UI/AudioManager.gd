extends Node

var playing = []
func _finished_playing(id, sound, object):
	if object:
		object.remove_child(sound)
		object.playing = false
	else:
		remove_child(sound)
	playing.remove(id)
func play_sound(sound_file, volume = 1, loop = false, object = null, player = null):
	if sound_file:
		var sound
		if object:
			sound = AudioStreamPlayer2D.new()
		else:
			sound = AudioStreamPlayer.new()
		if object:
			object.add_child(sound)
		else:
			add_child(sound)

		sound.stream = load(sound_file)
		if sound.stream is AudioStreamOGGVorbis:
			sound.stream.loop = loop
		sound.volume_db = volume
		sound.bus = "Sound"
		sound.connect("finished", self, "_finished_playing", [playing.size(), sound, object])
		sound.play()
		playing.append({"sound": sound, "volume": sound.volume_db, "object": object, "player": player })
		return sound
func _process(_delta):
	for play in playing:
		if play.object and play.player:
			var pos_diff = play.object.position - play.player.position
			pos_diff =  abs(abs(pos_diff.x) - abs(pos_diff.y)) / 100 
			play.sound.volume_db = play.volume - pos_diff
