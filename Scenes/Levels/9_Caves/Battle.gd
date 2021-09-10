extends Node2D

onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var affogato = get_tree().get_current_scene().get_node("Default/Affogato")
onready var camera = player.get_node("Camera2D")
onready var trigger_battle = $TriggerBattle
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var enemy = $Enemy
onready var boulder = $Boulder
onready var ceiling = $Ceiling

var defeated = false
var start_ticker = 0
var nyrn_chat = 0

func _ready():
	if not defeated:
		phase = 1
		enemy.sprite.visible = true
		enemy.sprite.frame = 0
		enemy.sprite.playing = true
		ceiling.sprite.frame = 0

var shoot_rock
var boulder_fall
var dodging 
var attack_ticker = 0

var phase
func _phase_one():
	if trigger_battle.touching:
		affogato.visible = false
		if not player.disabled:
			player.disable()
		if camera.position.x < 350 and not shoot_rock:
			camera.position.x += 2
			camera.zoom *= 1.001
		elif not chat_with.started:
			attack_ticker += 1
			if nyrn_chat == 0:
				chat_with.visible = true
				chat_with.start("norna_wyrd_caves_" + str(nyrn_chat), true, false)
				nyrn_chat += 1
				shoot_rock = true
			elif shoot_rock and (enemy.sprite.frame == 1 or enemy.sprite.frame == 6) and attack_ticker % 20 == 0 and enemy.attacks.size() < 4 and not enemy.bullets.size() > 3: 
				enemy.sprite.playing = false
				enemy.attack_target(boulder.position - Vector2(-30, -140))
			elif enemy.bullets.size() > 0:
				camera.position.x -= 1.6
				camera.position.y -= .1
				camera.zoom *= .998
	if ceiling.hp < 100:
		phase = 2
	

func _phase_two():

	if ceiling.hp <= 0:
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
		if phase == 1:
			_phase_one()
		elif phase == 2:
			_phase_two()
