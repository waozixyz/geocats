extends Node2D

onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var affogato = get_tree().get_current_scene().get_node("Default/Affogato")
onready var camera = player.get_node("Camera2D")
onready var trigger_battle = $TriggerBattle
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var enemy = $Enemy
onready var boulder = $Boulder

var defeated = false
var start_ticker = 0
var nyrn_chat = 0

func _ready():
	if not defeated:
		enemy.sprite.visible = true
		enemy.sprite.frame = 0
		enemy.sprite.playing = true

var shoot_rock
var boulder_fall
var dodging 
func _phase_one():
	if trigger_battle.touching:
		affogato.visible = false
		if not player.disabled:
			player.disable()
		if camera.position.x < 350:
			camera.position.x += 2
			camera.zoom *= 1.001
		elif not chat_with.started:
			if nyrn_chat == 0:
				chat_with.visible = true
				chat_with.start("norna_wyrd_caves_" + str(nyrn_chat), true, false)
				nyrn_chat += 1
				shoot_rock = true
			elif shoot_rock and enemy.sprite.frame == 1:
				enemy.sprite.playing = false
				var done = enemy.make_beam()
				if done:
					boulder_fall = true
					shoot_rock = false


	if boulder_fall:
		boulder.visible = true
		if boulder.position.y > -70:
			if not dodging:
				player.velocity.x += 250
				player.jump(100)
			dodging = true
		if boulder.position.y < 66.5:
			boulder.get_node("Sprite").rotation_degrees += 2
			boulder.position.y += 1
		else:
			boulder_fall = false
			player.enable()
func _process(delta):
	if start_ticker > 5:
	#	player.state_machine.change_state("climb")
		pass
	else:
		start_ticker += 1
	if not defeated:
		_phase_one()
	
