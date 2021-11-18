extends Area2D

onready var letter = get_tree().get_current_scene().get_node("CanvasLayer/Letter")
onready var interact_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/SimpleInteract")
onready var sprite = $Sprite
var touching = false

func _ready():
	set_process_input(true)
	var err = connect("body_entered", self, "_on_body_entered")
	assert(err == OK)
	err = connect("body_exited", self, "_on_body_exited")
	assert(err == OK)
	if PROGRESS.variables.get("cradle_present_open"):
		sprite.visible = false
	
func _on_body_entered(body):

	if body.name == "Player":
		touching = true
		if sprite.visible:
			interact_with.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
		interact_with.visible = false

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact"):
		# if the letter is visible and the present is not visible
		if letter.visible and sprite.visible == false:
			interact_with.visible = false
			letter.visible = false
		# if im touching the present and the present is visible
		if touching and sprite.visible:
			letter.visible = true
			sprite.visible = false
			PROGRESS.variables["cradle_present_open"] = true

