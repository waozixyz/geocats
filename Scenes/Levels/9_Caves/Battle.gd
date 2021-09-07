extends Node2D

onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var affogato = get_tree().get_current_scene().get_node("Default/Affogato")
onready var camera = player.get_node("Camera2D")
onready var battle = $TriggerBattle

var start = true

var ticker = 0
func _process(delta):
	ticker += 1
	if ticker > 5 and start:
	#	player.state_machine.change_state("climb")
		start = false
	if battle.touching:
		affogato.visible = false
		player.disabled = true
		if camera.position.x < 350:
			camera.position.x += 2
		if camera.zoom.x < 1.19:
			camera.zoom *= 1.001
