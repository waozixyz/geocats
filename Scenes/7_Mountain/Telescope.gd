extends Area2D

onready var interact_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/SimpleInteract")
onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var camera = get_tree().get_current_scene().get_node("Default/Player/Camera2D")

onready var thank_you = get_tree().get_current_scene().get_node("CanvasLayer/ThankYou")

var touching = false
var game_finished = false

func _ready():
	set_process_input(true)
	assert(connect("body_entered", self, "_on_body_entered") == 0)
	assert(connect("body_exited", self, "_on_body_exited") == 0)

func _on_body_entered(body):

	if body.name == "Player":
		touching = true
		interact_with.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
		interact_with.visible = false

func _process(delta):
	if game_finished:	
		player.disabled = true
		interact_with.visible = false
		if camera.zoom.x < 7:
			camera.zoom.x += 0.01
			camera.zoom.y += 0.01
			camera.position.x += 1
		else:
			thank_you.visible = true
			

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact"):
		if touching:
			game_finished = true
