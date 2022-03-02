extends E_Interact

class_name Consumable, "res://Assets/UI/Debug/consumable_icon.png"

export(NodePath) var make_node_visible
export(NodePath) var consumable_path
export(String) var progress_var

var consumable
var ui_node

func _ready():
	hide_when_playing = false
	ui_node = get_node(make_node_visible)

	if consumable_path:
		consumable = get_node(consumable_path)

	if progress_var:
		if PROGRESS.variables.get(progress_var):
			consumable.visible = false

func _process(_delta): 
	if do_something  and ui_node.modulate.a == 1:
		do_something = false
		disabled = true
		ui_node.visible = false
		remove_child(interact_with.get_parent())
		if not disable_player.empty():
			player.enable(disable_player)
		return
	
	if do_something and not disabled:
		if consumable.visible:
			utils.tween_fade(ui_node, 0, 1, 0.2)
		else:
			utils.tween_fade(ui_node, 1, 0, 0.2)
		if progress_var:
			PROGRESS.variables[progress_var] = true
		if consumable:
			consumable.visible = false
		do_something = false
		disable_sound = true
		

