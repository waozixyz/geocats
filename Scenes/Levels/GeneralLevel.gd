extends Node2D
class_name GeneralLevel

export(Vector2) var respawn_location
export(bool) var reload_on_death
var locations : PoolVector2Array
var dead
var music = get_node_or_null("Music") setget, _get_music
var player = get_node_or_null("Default/Player") setget ,_get_player
var camera = get_node_or_null("Default/Player/Camera2D") setget, _get_camera

var disable = {
	player = [],
	e_interact = []
}


func set_disable(obj: String, reason: String, state = true):
	if state:
		if not disable[obj].has(reason):
			disable[obj].append(reason)
	else:
		disable[obj].remove(reason)
		
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
		camera = get_node_or_null("Default/Player/Camera2D")
		if not camera:
			printerr("can't find camera node: ", camera)
	return camera
func _get_player():
	if not player:
		player = get_node_or_null("Default/Player")
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
func _ready():
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
		global.user.hp += 1
	elif dead and not tween.is_active():
		if reload_on_death:
			var err = get_tree().reload_current_scene()
			assert(err == OK)
		else:
			set_disable("player", "dead", false)
			dead = false
	if reload_on_death and dead and not tween.is_active():
		player.position = respawn_location
		
