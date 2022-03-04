extends Area2D

onready var player =  get_tree().get_current_scene().get_node("Default/Player")

var inside = false
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		inside = true

func _process(delta):
	var dfps = delta * global.fps
	if inside:
		global.user.hp -= .8 * dfps
		
func _on_body_exited(body):
	if body.name == "Player":
		inside = false
