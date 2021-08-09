extends Area2D

onready var player =  get_tree().get_current_scene().get_node("Default/Player")
var disabled: bool = false

func _ready():
	assert(connect("body_entered", self, "_on_body_entered") == 0)
	assert(connect("body_exited", self, "_on_body_exited") == 0)


func _on_body_entered(body):
	if body.name == "Player" and not disabled:
		AudioStreamManager.play("res://Assets/Sfx/SFX/Effect__Gramophone.ogg")
