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
		if camera.modulate.a == 1:
			utils.tween(camera, "zoom", Vector2(9, 9), 2)
			timer = 0
			if active_sound:
				active_sound.stop()
			if not disable_player.empty():
				current_scene.set_disable("player", disable_player, false)
				
		else:
			utils.tween(camera, "zoom", Vector2(0, 0), 2)
			if sound_when_visible:
				active_sound = AudioManager.play_sound(sound_when_visible, sound_volume, true)
			timer = 0
		do_something = false

	
