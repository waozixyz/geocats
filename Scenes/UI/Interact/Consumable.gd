extends E_Interact

class_name Consumable, "res://Assets/UI/Debug/consumable_icon.png"

export(NodePath) var make_node_visible
export(NodePath) var consumable_path
export(String) var progress_var

var consumable
var ui_node

func _ready():
	ui_node = get_node(make_node_visible)

	if consumable_path:
		consumable = get_node(consumable_path)

	if progress_var:
		if PROGRESS.variables.get(progress_var):
			consumable.visible = false

func _process(delta): 
	if ui_node.visible == false and consumable.visible == false:
		do_something = false
		remove_child(interact_with.get_parent())
	if do_something:
		ui_node.visible = utils.toggle(ui_node.visible)
		if progress_var:
			PROGRESS.variables[progress_var] = true
		if consumable:
			consumable.visible = false
		do_something = false
		
