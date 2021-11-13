extends Node2D

onready var music_intro = $MusicIntro
onready var music_main = $MusicMain
onready var music_outro = $MusicOutro

onready var nft = get_tree().get_current_scene().get_node("Default/NFT")
onready var player = get_tree().get_current_scene().get_node("Default/Player")
onready var affogato = get_tree().get_current_scene().get_node("Default/Affogato")
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")

onready var camera = player.get_node("Camera2D")
onready var trigger_battle = $TriggerBattle

onready var enemy = $Enemy
onready var boulder = $Boulder
onready var ceiling = $Ceiling

onready var hp_bar = $HUD/HpBar

var defeated = false
var start_ticker = 0
var nyrn_chat = 0
var death_location = 1

func _intro_done():
	music_main.play()

func _main_done():
	music_outro.play()

var norna_nft = "Norna Pixels"
var wyrd_nft = "Wyrd Pixels"
	
func _ready():
	defeated = PROGRESS.variables.get("CavesBattleDefeated")
	if not defeated:
		music_outro.stream.loop = false
		music_intro.stream.loop = false
		music_intro.connect("finished", self, "_intro_done")
		music_main.connect("finished", self, "_main_done")
		phase = 1
		enemy.sprite.visible = true
		enemy.sprite.frame = 0
		enemy.sprite.playing = true
		ceiling.sprite.frame = 0
	else:
		enemy.sprite.visible = false

var shoot_rock
var boulder_fall
var dodging
var phase
func _phase_one(dfps):
	if trigger_battle.touching:
		affogato.visible = false
		if player.disable_reasons.size() == 0:
			player.disable("Battle")
		if camera.offset.x < 350 and not shoot_rock:
			camera.offset.x += 2
			camera.zoom *= 1.001
		elif not chat_with.started:
			if nyrn_chat == 0:
				chat_with.visible = true
				chat_with.start("norna_wyrd_caves_" + str(nyrn_chat), true, false)
				nyrn_chat += 1
				music_intro.play()
				shoot_rock = true
			elif shoot_rock and (enemy.sprite.frame == 3 or enemy.sprite.frame == 9) and enemy.sprite.playing: 
				enemy.sprite.playing = false
				enemy.beam_attack()
			_fix_cam()
	if ceiling.hp < 100:
		phase = 2

func _fix_cam():
	if camera.offset.x > 0:
		camera.offset.x -= 1.2
	if camera.zoom.x > 1:
		camera.zoom *= .998
var start_count = 30
func _phase_two(dfps):
	if ceiling.hp <= 0:
		boulder.visible = true
		boulder.scale.x += 0.001 
		boulder.scale.y += 0.001 
		if boulder.position.y > -30:
			if not dodging:
				player.velocity.x += 250
				player.jump(120)
			dodging = true
			_fix_cam()
		if boulder.position.y < 50:
			boulder.get_node("Sprite").rotation_degrees += 2
			boulder.position.y += 1 * dfps
		else:
			camera.shake = 6
			boulder.get_node("SoundLanding").play()
			player.enable("Battle")
			boulder_fall = false
			phase = 3
	
func _pre_chat():
	if player.disable_reasons.size() == 0:
		player.disable("Battle")
	enemy.shooting = false
	enemy.ears.visible = false
	enemy.vulnerable = false
	chat_with.visible = true

func _phase_three():
	_fix_cam()
	if enemy.moves.size() <= 0 and enemy.mode == 0:
		enemy.move()
	if enemy.hp <= 40:
		_pre_chat()
		chat_with.start("norna_wyrd_caves_1", true, false)
		phase = 4
		# bug notproceeding

func _phase_four(dfps):
	if not chat_with.started and player.disable_reasons.size() != 0:
		player.enable("Battle")
		chat_with.visible = false
		enemy.vulnerable = true
		enemy.rage = 1
		enemy.move_speed *= 2
		enemy.def = 2
		enemy.move()
	if enemy.hp <= 0:
		_pre_chat()
		chat_with.start("norna_wyrd_caves_2", true, false)
		phase = 5

func _phase_five():
	if not chat_with.started and player.disable_reasons.size() != 0:
		music_main.stream.loop = false
		enemy.sprite.frame = 0
		enemy.sprite.animation = "die"
		enemy.sprite.playing = true
		nft.reward(norna_nft, false)
		nft.reward(wyrd_nft, false)
		phase = 6

func _phase_six():
	if enemy.sprite.frame == 3:
		boulder.hp = 0
		boulder.breakable = true
		enemy.visible = false
		enemy.disable_colliders()
		defeated = true
		PROGRESS.variables["CavesBattleDefeated"] = true
		player.enable("Battle")
		
func _process(delta):
	var dfps = delta * global.fps
	if start_ticker > 2 and start_ticker < 6 and player.position.x < 200:
		player.state_machine.change_state("climb")
		player.on_ladder = true
	start_ticker += 1
	affogato.visible = false
	phase == 6
	if not defeated and floor(global.data.player_hp) > 0:
		if phase == 1:
			_phase_one(dfps)
		elif phase == 2:
			_phase_two(dfps)
		elif phase == 3:
			_phase_three()
		elif phase == 4:
			_phase_four(dfps)
		elif phase == 5:
			_phase_five()
		elif phase == 6:
			_phase_six()
		if not chat_with.started and phase > 2:
			hp_bar.visible = true
		else:
			hp_bar.visible = false
	else:
		hp_bar.visible = false


