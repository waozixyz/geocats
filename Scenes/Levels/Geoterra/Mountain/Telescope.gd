extends E_Interact

onready var camera = current_scene.camera

var zoom_org : float = 0.0
export(bool) var skip_var
export(String, FILE, "*.wav, *.ogg") var sound_when_visible 

func _ready():
	pass

var active_sound
func _process(_delta): 
	if do_something and camera:
		if camera.zoom.x == 1.5:
			utils.tween(camera, "zoom", Vector2(9, 9), 1)
			timer = 0
		else:
			utils.tween(camera, "zoom", Vector2(1.5, 1.5), 1)
			if sound_when_visible:
				active_sound = AudioManager.play_sound(sound_when_visible, sound_volume, true)
			if not disable_player.empty():
				current_scene.set_disable("player", disable_player, false)
			timer = 0
		do_something = false

	
