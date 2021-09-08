extends Node2D

onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var affogato = get_tree().get_current_scene().get_node("Default/Affogato")
onready var camera = player.get_node("Camera2D")
onready var trigger_battle = $TriggerBattle
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var enemy = $Enemy

var defeated = false
var start_ticker = 0
var nyrn_chat = 0

func _ready():
	if not defeated:
		enemy.sprite.visible = true
	enemy.sprite.frame = 1
	enemy.sprite.playing = false

	



func _process(delta):
	enemy.make_beam()
	if start_ticker > 5:
	#	player.state_machine.change_state("climb")
		pass
	else:
		start_ticker += 1
	if not defeated:
		if trigger_battle.touching:
			affogato.visible = false
			player.disabled = true
			if camera.position.x < 350:
				camera.position.x += 2
				camera.zoom *= 1.001
			elif not chat_with.started:
				if nyrn_chat == 0:
					chat_with.visible = true
					chat_with.start("norna_wyrd_caves_" + str(nyrn_chat), true, false)
					nyrn_chat += 1
				else:
					if enemy.sprite.frame == 1:
						enemy.sprite.playing = false
						enemy.make_beam()
