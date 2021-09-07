extends Node2D

onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var affogato = get_tree().get_current_scene().get_node("Default/Affogato")


var start = true
var battle = false

var ticker = 0
func _process(delta):
	ticker += 1
	
	if ticker > 5 and start:
		player.state_machine.change_state("climb")
		start = false
	if battle:
		affogato.visible = false
	battle = true
