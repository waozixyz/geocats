extends Area2D

onready var player =  get_tree().get_current_scene().get_node("Default/Player")
onready var crt =  get_tree().get_current_scene().get_node("Default/CRT_Effect/ColorRect")

var inside = false
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		inside = true

func _process(_delta):
	if inside:
		player.hp -= 2
		
func _on_body_exited(body):
	if body.name == "Player":
		inside = false
