extends Area2D


func _ready():
	connect("body_entered", self, "_on_body_enter")

func _input(event):
	if Input.is_action_pressed("interact"):
		get_parent().visible = false
func _on_body_enter(body):
	if body.name == "Player":
		print("hi")
