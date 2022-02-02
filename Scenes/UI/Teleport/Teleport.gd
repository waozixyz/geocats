extends S_Interact
class_name Teleport, "res://Assets/UI/Debug/teleport_icon.png"

var sound_path = "res://Assets/UI/Teleport/"
enum Sounds {
	Elevator
	FootstepsFastSand
	FootstepsOnGravelFast
	OrganicSmashLilCave
	WayoWayo
	WoodDoorLatchOpen1
}

export(Sounds) var sound_effect
export(float) var sound_volume = 1.0

func _play_sound():
	var path = sound_path + Sounds.keys()[sound_effect]
	path = path + utils.find_sound_ext(path)
		

	AudioManager.play_sound(path, sound_volume)
