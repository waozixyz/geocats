extends Area2D

signal splash

#onready var splash : Particles2D = $Splash

func _ready():
	assert(connect("body_entered", self, "_on_body_entered") == 0)
	assert(connect("body_exited", self, "_on_body_exited") == 0)
#	material.set_shader_param("sprite_scale", scale)
	pass
func _on_body_entered(body):
	if body.name == "Player":
		if body.underwater != null:
			body.underwater = true

			emit_signal("splash", body.position.x)

func _on_body_exited(body:PhysicsBody2D):
	if body.name == "Player":
		if body.underwater != null: 
			body.underwater = false
			emit_signal("splash", body.position.x)
