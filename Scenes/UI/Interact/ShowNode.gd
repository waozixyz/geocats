extends E_Interact

class_name ShowNode, "res://Assets/UI/Debug/consumable_icon.png"

export(NodePath) var make_node_visible
export var transition_time = 0.2
export(String, FILE, "*.wav, *.ogg") var sound_when_visible 
var ui_node

func _ready():
	hide_when_playing = false
	ui_node = get_node(make_node_visible)

var active_sound
func _process(_delta): 
	if do_something:
		if ui_node.modulate.a == 1:
			utils.tween_fade(ui_node, 1, 0, transition_time)
			timer = 0
			if active_sound:
				active_sound.stop()
			if not disable_player.empty():
				player.enable(disable_player)
		else:
			utils.tween_fade(ui_node, 0, 1, transition_time)
			if sound_when_visible:
				active_sound = AudioManager.play_sound(sound_when_visible, 1, true)
			timer = 0
		do_something = false

	
