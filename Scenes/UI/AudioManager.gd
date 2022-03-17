extends Node

var player

var id = 0
var playing = {}

func _ready():
	if not get_tree().get_current_scene().get("player") == null:
		player = get_tree().get_current_scene().player

func _finished_playing(id, sound, object):
	if object:
		object.remove_child(sound)
		object.playing = false
	else:
		remove_child(sound)
	playing.erase(id)

func play_sound(sound_file, volume = 100, loop = false, object = null):
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
		sound.volume_db = linear2db(volume * 0.01)
		sound.bus = "Sound"
		sound.connect("finished", self, "_finished_playing", [id, sound, object])
		sound.play()
		playing[id] = {"sound": sound, "volume": sound.volume_db, "object": object}
		id += 1
		return sound
func _process(_delta):
	if not get_tree().get_current_scene().get("player") == null and player == null:
		player = get_tree().get_current_scene().player

	if (!weakref(player).get_ref()) and not player == null:
		player = get_tree().get_current_scene().player

	
	for item in playing.values():
		if item.object and player is KinematicBody2D:
			if !weakref(item.object).get_ref():
				playing.erase(item)
			else:
				var pos_diff = item.object.position - player.position
				pos_diff =  abs(abs(pos_diff.x) - abs(pos_diff.y)) / 100 
				item.sound.volume_db = item.volume - pos_diff
		elif item.sound.volume_db != item.volume:
			item.sound.volume_db = item.volume
