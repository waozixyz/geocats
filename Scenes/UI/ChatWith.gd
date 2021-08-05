extends Control
onready var dialogue = $Dialogue
onready var panel = $Panel
onready var name_label = $Panel/NameLabel

var started : bool = false
var hide_after: bool = false
func start(name, hide = false):
	hide_after = hide

	if not started:
		dialogue.exit()
		dialogue.initiate(name.to_lower())
		started = true

func stop():
	started = false
	dialogue.exit()
	if hide_after:
		visible = false

	#get_parent().idle = false
func _process(_delta):
	if dialogue.frame.visible:
		panel.visible = false
		started = true
	else:
		panel.visible = true
		started = false

		if hide_after:
			visible = false

