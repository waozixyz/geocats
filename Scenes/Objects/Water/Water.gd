extends Area2D

signal splash

#onready var splash : Particles2D = $Splash
export var slime = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
#	material.set_shader_param("sprite_scale", scale)
	pass

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
