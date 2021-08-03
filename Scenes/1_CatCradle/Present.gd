extends Area2D

onready var letter = get_tree().get_current_scene().get_node("CanvasLayer/Letter")
onready var interact_with = get_tree().get_current_scene().get_node("CanvasLayer/InteractWith")
var touching = false

func _ready():
	set_process_input(true)
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	if not global.data.present:
		get_parent().visible = false
	
func _on_body_entered(body):

	if body.name == "Player":
		touching = true
		if get_parent().visible:
			interact_with.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
		interact_with.visible = false

func _input(event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact"):
		# if the letter is visible and the present is not visible
		if letter.visible and get_parent().visible == false:
			interact_with.visible = false
			letter.visible = false
		# if im touching the present and the present is visible
		if touching and get_parent().visible:
			letter.visible = true
			get_parent().visible = false
			global.data.present = false


