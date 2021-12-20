extends CanvasLayer

onready var chat_with = $ChatWith
onready var sprite = $AnimatedSprite
onready var container = $Container
onready var MusicPlayer = $AudioStreamPlayer
onready var pause = $Pause
onready var tween = $Tween

var location : int
var scene : String 
var prev_scene : String
var timer : int
var load_time : int = 40
var change : bool

func _ready():
	sprite.modulate.a = 0
	container.modulate.a = 0

func _get_scene(scene_name):
	var pos = null
	var dir = 1
	match scene_name:
		"TitleScreen":
			return ["res://Scenes/Levels/0_TitleScreen/TitleScreen.tscn", pos, dir]
		"CatsCradle":
			match location:
				1: 
					pos = Vector2(25, 950 * 0.7)
			return ["res://Scenes/Levels/1_CatCradle/1_CatCradle.tscn", pos, dir]
		"Complex":
			match location:
				1: 
					pos = Vector2(400, 1077)
			return ["res://Scenes/Levels/2_Complex/2_Complex.tscn", pos, dir]
		"GeoCity":
			match location:
				1: 
					pos = Vector2(2630, 1010)
				2:
					pos = Vector2(1023, 1010)
			return ["res://Scenes/Levels/3_GeoCity/3_GeoCity.tscn", pos, dir]
		"PopNnip":
			match location:
				1: 
					pos = Vector2(720, 423)
			return ["res://Scenes/Levels/4_PopNnip/4_PopNnip.tscn", pos, dir]
		"Arcade":
			return ["res://Scenes/Levels/4_PopNnip/Arcade.tscn", pos, dir]
		"DonutShop":
			return ["res://Scenes/Levels/5_DonutShop/5_DonutShop.tscn", pos, dir]
		"Creek":
			match location:
				1: 
					pos = Vector2(5500, 4120)
				2:
					pos = Vector2(2950, 3460)
				3:
					pos = Vector2(8800, 4900)
				4:
					dir = -1
					pos = Vector2(8900, 950)
				5:
					pos = Vector2(4420, 4950)
			return ["res://Scenes/Levels/6_Creek/6_Creek.tscn", pos, dir]
		"CavityPuzzleRoom":	
			return ["res://Scenes/Levels/6_Creek/1_CavityPuzzleRoom.tscn", pos, dir]
		"JokeRoom":	
			return ["res://Scenes/Levels/6_Creek/2_JokeRoom.tscn", pos, dir]
		"GeoCacheRoom":	
			return ["res://Scenes/Levels/6_Creek/3_GeoCacheRoom.tscn", pos, dir]
		"Mountain":	
			return ["res://Scenes/Levels/7_Mountain/7_Mountain.tscn", pos, dir]
		"GeoLodge":
			return ["res://Scenes/Levels/8_GeoLodge/8_GeoLodge.tscn", pos, dir]
		"Caves":
			match location:
				1: 
					pos = Vector2(500, 2120)
			return ["res://Scenes/Levels/9_Caves/9_Caves.tscn", pos, dir]
		"CaveBattle":
			match location:
				1: 
					pos = Vector2(426, 220)
			return ["res://Scenes/Levels/9_Caves/Battle.tscn", pos, dir]

func _tween(obj, start, end, time = .5):
	tween.interpolate_property(obj, "modulate:a", start, end, time, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

func change_scene(new_scene, new_location = 0, sound = "", volume = 1):
	if not sound == "":
		MusicPlayer.stream = load("res://Assets/Sounds/Transition/" + sound + ".ogg")
		MusicPlayer.stream.set_loop(false)
		MusicPlayer.set_volume_db(linear2db(volume))
		MusicPlayer.play()
	get_tree().paused = true
	prev_scene = scene
	scene = new_scene
	location = int(new_location)
	change = true
	_tween(sprite, 0, 1)
	_tween(container, 0, 1)

var request : HTTPRequest
func _physics_process(delta):
	var dfps = delta * Global.fps
	if get_tree().paused and not Global.pause_msg.empty():
		pause.visible = true
		pause.text = Global.pause_msg
	else:
		pause.visible = false
		
	if change:
		timer += dfps
		if timer  > load_time:
			_new_scene()
			
	# check master volume
	var i = AudioServer.get_bus_index("Master")
	var volume = AudioServer.get_bus_volume_db(i)
	if floor(Global.data.player_hp) <= 0.0:
		chat_with.start("feline_emergency_teleport")
		chat_with.visible = true
		get_tree().paused = true
		# lower volume
		if volume > -80:
			AudioServer.set_bus_volume_db(i, volume - .5)
	else:
		chat_with.visible = false
		if volume < 0:
			AudioServer.set_bus_volume_db(i, volume + .5)
		
	if request:
		var body_size = request.get_body_size()
		if body_size > 0:
			_check_response(API.response)
			API.remove_child(request)
			request = null

func _check_response(res):
	# api set location finished
	if res:
		if res.has('process'):
			if res['process'] == "location":
				if res.has('scene') and res.has('location'):
					SceneChanger.change_scene(res.scene, res.location)
				else:
					# load scene data
					var scene_data = _get_scene(scene)
					# change scene
					var _null = get_tree().change_scene(scene_data[0])
					# update game variables
					Global.player_position = scene_data[1]
					Global.player_direction = scene_data[2]
				_disable_animation()
		if res.has('season'):
			Global.data.season = res['season']
		print(res)
		
func _input(event):
	if chat_with.visible:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
			chat_with.visible = false
			Global.data.player_hp = 100.0
			var current_scene = get_tree().get_current_scene()
			change_scene(current_scene.name, current_scene.death_location, "", 1)
	if pause.visible:
		if event.is_action_pressed("ui_accept") or event.is_action_pressed("interact"):
			get_tree().paused = false
			Global.pause_msg = ""


	
func _disable_animation():
	get_tree().paused = false
	
	_tween(sprite, 1, 0, .2)
	_tween(container, 1, 0)
	
func _new_scene():
	timer = 0
	if scene == "TitleScreen" or get_tree().get_current_scene().name == "TitleScreen":
		var err = get_tree().change_scene(_get_scene(scene)[0])
		assert(err == OK)
		_disable_animation()
	else:
		request = API.get_request("/set-user-location", { "scene": scene, "location": location })
	change = false

