extends Area2D

onready var hud = get_tree().get_current_scene().get_node("CanvasLayer/HUD")
onready var interact_with = get_tree().get_current_scene().get_node("CanvasLayer/InteractWith")


func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(body):

	if body.name == "Player":
		if get_parent().visible:
			hud.visible = true
	
func _on_body_exited(body):
	hud.visible = false

func _input(event):
	pass
