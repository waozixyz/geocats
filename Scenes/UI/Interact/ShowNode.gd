extends E_Interact

class_name ShowNode, "res://Assets/UI/Debug/consumable_icon.png"

export(NodePath) var make_node_visible
export var transition_time = 0.2
var ui_node

func _ready():
	hide_when_playing = false
	ui_node = get_node(make_node_visible)

func _process(_delta): 
	if do_something:
		if ui_node.modulate.a == 1:
			utils.tween_fade(ui_node, 1, 0, transition_time)
			
			if not disable_player.empty():
				player.enable(disable_player)
		else:
			utils.tween_fade(ui_node, 0, 1, transition_time)
		do_something = false

