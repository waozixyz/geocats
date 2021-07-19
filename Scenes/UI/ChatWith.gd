extends Control
onready var dialogue = $Dialogue
onready var panel = $Panel
onready var name_label = $Panel/NameLabel

var started : bool = false
func start(name):
	if not started:
		dialogue.initiate(name.to_lower())
		started = true

func stop():
	started = false
	dialogue.frame.hide()

	#get_parent().idle = false
func _process(delta):
	if dialogue.frame.visible:
		panel.visible = false
		started = true
	else:
		panel.visible = true
		started = false

