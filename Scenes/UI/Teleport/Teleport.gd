extends S_Interact
class_name Teleport, "res://Assets/UI/Debug/teleport_icon.png"

enum Sounds {
	None
	Elevator
	FootstepsFastSand
	FootstepsOnGravelFast
	OrganicSmashLilCave
	WayoWayo
	WoodDoorLatchOpen1
	GroundCatJokeRoom
}

export(Sounds) var sound_effect
export(float) var sound_volume = 1.0

func _play_sound():
	if sound_effect != Sounds.None:
		var file_path = utils.get_teleport_sound( Sounds.keys()[sound_effect])
		AudioManager.play_sound(file_path, sound_volume)
