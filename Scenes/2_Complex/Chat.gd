extends Area2D

onready var player =  get_tree().get_current_scene().get_node("Player")
onready var chat_with = get_tree().get_current_scene().get_node("CanvasLayer/ChatWith")

var active_name : String

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func show_chat():
	chat_with.visible = true
	chat_with.name_label.text = active_name

func hide_chat():
	chat_with.visible = false
	chat_with.stop()
	active_name = ""

func _on_body_entered(body):
	if body.name == "Player":
		active_name = get_parent().name
		show_chat()

func _on_body_exited(body):
	if body.name == "Player":
		hide_chat()

func _process(delta):
	if active_name == get_parent().name and "idle" in get_parent():
		if chat_with.started:
			get_parent().idle = true
		else:
			get_parent().idle = false

func _input(event):
	if active_name == get_parent().name:
		if Input.is_action_just_pressed("interact"):
			chat_with.start(active_name)
