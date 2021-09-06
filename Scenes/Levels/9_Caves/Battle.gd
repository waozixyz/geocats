extends Node2D

onready var player = get_tree().get_current_scene().get_node("Default/Player")


var start = true

func _process(delta):
	if start:
		player.state_machine.change_state("climb")
		start = false
