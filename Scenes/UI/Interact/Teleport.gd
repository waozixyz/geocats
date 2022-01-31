extends InteractButton
class_name TeleportInteract, "res://Assets/UI/Debug/teleport_icon.png"

export(String, FILE, "*.wav, *.ogg") var sound_effect
export(String, FILE, "*.tscn") var scene_path
export(int) var location = 0

func _input(_event):
	if _can_interact():
		global.user.location = location
		SceneChanger.change_scene(scene_path)
		AudioManager.play_sound(sound_effect)
		object.visible = false


