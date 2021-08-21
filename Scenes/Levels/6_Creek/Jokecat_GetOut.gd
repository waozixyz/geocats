extends Area2D

onready var chat_with =  get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var player =  get_tree().get_current_scene().get_node("Default/Player")

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

var in_contact : bool = false
func _on_body_entered(body):
	if body.name == "Player":
		chat_with.visible = true
		chat_with.start("joke_cat", true)
		player.disabled = true
		player.vx = 0
		player.sprite.play("idle")
		in_contact = true
		

func _on_body_exited(body):
	if body.name == "Player":
		in_contact = false


func _process(delta):
	if in_contact:
		if not chat_with.started:
			player.position.x -= 20
			player.position.y -= 10
			player.sprite.flip_h = -1
			player.disabled = false
