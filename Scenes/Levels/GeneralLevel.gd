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
	chat_with = [],
	feline = []
}

var chatting = []

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

var followers = []

func add_follower(cat):
	if cat is SimpleMovingAI:
		cat.change_direction = 0
		cat.jump_height = 0
		cat.move_speed = 0
	if has_node(cat.name):
		remove_child(get_node(cat.name))

	if not global.user.following.has(cat.name):
		global.user.following.append(cat.name)
	followers.append(cat)
	if cat.get_parent():
		cat.get_parent().remove_child(cat)
	cat.manage_anim = false
	add_child( cat)
	move_child(cat, player.get_index())
	cat.set_owner(self)
	cat.sprite.play("idle")
	if cat.has_node("ChatNPC"):
		cat.get_node("ChatNPC").disabled = true


func remove_follower(cat, full_remove = true):
	if cat:
		if global.user.following.has(cat.name):
			global.user.following.remove(cat.name)
		followers.erase(cat)
		cat.velocity = Vector2(0,0)
		if full_remove:
			remove_child(cat)
		
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

	for follower in global.user.following:
		var follower_scene = load(utils.find_agent_path(follower))
		if follower_scene:
			add_follower(follower_scene.instance())
		else:
			printerr("follower invalid: ", follower)


var tween
func _process(_delta):
	# dying logic
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
	
	

	# follow player logic

	if player.position_log.size() > followers.size() * 5:
		for i in followers.size():
			var follower = followers[i]
			var order = follower.follow_order
			var anim = "idle"

			if player.anime_log[order] == "climb":
				anim = player.anime_log[order]
			var obj = player
			if i > 0:
				obj = followers[i - 1]
			var diff = player.position_log[order] - obj.position

			if (abs(diff.y) > 30 or not follower.is_on_floor()) and order < player.position_log.size() - 1:
				order += 1

				diff = player.position_log[order] - obj.position
			var max_skip = 10
			while(abs(diff.x) > 90) and order < player.position_log.size() - 1:
				anim = "walk"
				order += 1
				if abs(diff.y) > 30 and max_skip == 0:
					break
				max_skip -= 1
				diff = player.position_log[order] - obj.position
			
			# update sprite orientation
			if diff.x > 0:
				follower.sprite.flip_h = not player.sprite.flip_h or follower.mirror_sprite
			elif diff.x < 0:
				follower.sprite.flip_h = not (player.sprite.flip_h or follower.mirror_sprite)



			if follower.sprite.frames.has_animation(anim) and follower.sprite.animation != anim:
				follower.sprite.play(anim)
			follower.position = player.position_log[order] + Vector2(0, 4)
			follower.follow_order = order

