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
	WoodDoorLatchOpen2
	GroundCatJokeRoom
	MetalOpenLid
	GlassDoorOpen
}

export(Sounds) var sound_effect
export(float, 0, 100) var sound_volume = 100

func _play_sound():
	if sound_effect != Sounds.None:
		var file_path = utils.get_teleport_sound( Sounds.keys()[sound_effect])
		var sound = AudioManager.play_sound(file_path, sound_volume)

		sound.pause_mode = PAUSE_MODE_PROCESS
