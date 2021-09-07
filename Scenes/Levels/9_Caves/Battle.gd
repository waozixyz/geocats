extends Node2D

onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var affogato = get_tree().get_current_scene().get_node("Default/Affogato")


var start = true
var battle = false

func _process(delta):
	if start:
		#player.state_machine.change_state("climb")
		start = false
	if battle:
		affogato.visible = false
	battle = true
