extends Area2D

onready var computer = get_tree().get_current_scene().get_node("CanvasLayer/Computer")
onready var interact_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/SimpleInteract")
var touching = false

func _ready():
	set_process_input(true)
	var err = connect("body_entered", self, "_on_body_entered")
	assert(err == OK)
	err = connect("body_exited", self, "_on_body_exited")
	assert(err == OK)
	
func _on_body_entered(body):

	if body.name == "Player":
		touching = true
		interact_with.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
		interact_with.visible = false
		computer.visible = false

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact"):
		# if the letter is visible and the present is not visible
		if computer.visible == false:
			interact_with.visible = false
			computer.visible = false
		# if im touching the present and the present is visible
		if touching:
			computer.visible = true
			PROGRESS.variables["knowledge_on"] = true

