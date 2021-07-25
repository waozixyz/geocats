extends Area2D

onready var button = $Button
onready var sound = $Sound
onready var chat_with =  get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		button.visible = true

func _on_body_exited(body):
	if body.name == "Player":
		button.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_down") && button.visible == true && not chat_with.started:
		button.visible = false
		if name == "GoToComplex":
			SceneChanger.change_scene("Complex", 1, "FootstepsOnGravelFast", 1.5)
		if name == "PopNnip":
			SceneChanger.change_scene("PopNnip", 0, "WayoWayo", .5)
		if name == "DonutShop":
			if PROGRESS.variables.get("follow"):
				PROGRESS.variables.follow = false
				PROGRESS.variables.donut_open = true
			if  PROGRESS.variables.get("donut_open"):
				SceneChanger.change_scene("DonutShop", 0, "WayoWayo", .5)
			else:
				chat_with.visible = true
				chat_with.start("door_closed", true)
				button.visible = true
			

