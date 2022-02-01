extends InteractSimple

export(NodePath) var make_node_visible
export(NodePath) var consumable_path
export(String) var progress_var

var consumable
var ui_node

func _ready():
	hide_interact = false
	ui_node = get_node(make_node_visible)

	if consumable_path:
		consumable = get_node(consumable_path)

	if progress_var:
		if PROGRESS.variables.get(progress_var):
			consumable.visible = false

func _process(delta):
	if object and not ui_node.visible and consumable and not consumable.visible:
		do_something = false
		object.visible = false
		object = null
	if do_something:
		ui_node.visible = utils.toggle(ui_node.visible)
		if progress_var:
			PROGRESS.variables[progress_var] = true
		if consumable:
			consumable.visible = false
		do_something = false
