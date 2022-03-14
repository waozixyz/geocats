extends Area2D

signal splash

#onready var splash : Particles2D = $Splash
export var slime = false

func _ready():
	var err = connect("body_entered", self, "_on_body_entered")
	assert(err == OK)
	err = connect("body_exited", self, "_on_body_exited")
	assert(err == OK)


func _on_body_entered(body):
	if body.name == "Player":
		if body.underwater != null:
			body.underwater = true
			if slime:
				body.water_sub = "slime"
			else:
				body.water_sub = "water"

			emit_signal("splash", body.position.x)

func _on_body_exited(body:PhysicsBody2D):
	if body.name == "Player":
		if body.underwater != null: 
			body.underwater = false

			emit_signal("splash", body.position.x)
