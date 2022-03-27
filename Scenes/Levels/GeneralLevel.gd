extends Node2D
class_name GeneralLevel

export(Vector2) var respawn_location
export(bool) var reload_on_death
var locations : PoolVector2Array
var dead

var current_song = 0
export(Array, NodePath) var music = get_node_or_null("Music") setget, _get_music
var player = get_node_or_null("Player") setget ,_get_player
var camera = get_node_or_null("Player/Camera2D") setget, _get_camera


var disable = {
	player = [],
	e_interact = [],
	feline = []
}


func set_disable(obj: String, reason: String, state = true):
	if state:
		if not disable[obj].has(reason):
			disable[obj].append(reason)
	else:
		if disable[obj].has(reason):
			var pos = disable[obj].find(reason)
			disable[obj].remove(pos)
func is_disabled(obj : String, reason : String = ""):
	obj = obj.to_lower()
	
	if disable[obj].size() > 0:
		if not reason.empty():
			return disable[obj].has(reason)
		else:
			return true
	else:
		return false

func _get_camera():
	if not camera:
		camera = get_node_or_null("Player/Camera2D")
		if not camera:
			printerr("can't find camera node: ", camera)
	return camera
func _get_player():
	if not player:
		player = get_node_or_null("Player")
		if not player:
			printerr("can't find player node: ", player)
	return player

func _get_music():
	if not music:
		music = get_node_or_null("AudioStreamPlayer")
		if not music:
			music = get_node_or_null("BackgroundMusic")
			if not music:
				music = get_node_or_null("Music")
				if not music:
					printerr("could not find level music")

	return music

var canvas_layer
var feline = load("res://Scenes/UI/Feline/Feline.tscn").instance()
var crt_effect = load("res://Scenes/UI/CRT_Effect.tscn").instance()
var dialogue = load("res://Scenes/UI/Dialogue/Dialogue.tscn").instance()
var chat_with =  load("res://Scenes/UI/Interact/ChatWith.tscn").instance()
func _add_default_nodes():
	add_child(crt_effect)
	canvas_layer = CanvasLayer.new()
	add_child(canvas_layer)
	chat_with.visible = false
	canvas_layer.add_child(chat_with)
	canvas_layer.add_child(dialogue)
	canvas_layer.add_child(feline)
	
func next_song():
	if music is Array:
		music[current_song].stop()
		current_song += 1
		if current_song >= music.size():
			current_song = 0
		music[current_song].play()

func _init_music_array():
	if music is Array and music.size() > 0:
		var i = 0
		for m in music:
			music[i] = get_node(m)
			i += 1
func _ready():
	_add_default_nodes()
	_init_music_array()

	player = _get_player()
	camera = _get_camera()
	# set player location
	if locations:
		locations[0] = player.position
		if locations[global.user.location]:
			player.position = locations[global.user.location]
	if not respawn_location:
		respawn_location = player.position

var tween
func _process(_delta):
	if global.user.hp <= 0:
		tween = utils.tween(player, "position", respawn_location)
		set_disable("player", "dead")
		dead = true
	if dead and global.user.hp < 100:
		player.velocity.x = 0
		player.velocity.y = 0
		player.collision_layer = 0
		player.collision_mask = 0
		global.user.hp += 1
	elif dead and not tween.is_active():
		player.collision_layer = 1
		player.collision_mask = 1
		if reload_on_death:
			var err = get_tree().reload_current_scene()
			assert(err == OK)
		else:
			set_disable("player", "dead", false)
			dead = false
	if reload_on_death and dead and not tween.is_active():
		player.position = respawn_location
		
