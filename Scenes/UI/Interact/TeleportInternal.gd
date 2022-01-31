extends InteractButton
class_name TeleportInternal, "res://Assets/UI/Debug/teleport_icon.png"

export(String, FILE, "*.wav, *.ogg") var sound_effect
export(Vector2) var new_position 
export(float) var sound_volume = 1.0

func _input(_event):
	if _can_interact():
		AudioManager.play_sound(sound_effect, sound_volume)
		object.visible = false

		_teleport(new_position)
