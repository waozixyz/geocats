extends Node2D
class_name GeneralLevel

export(Vector2) var respawn_location
export(bool) var reload_on_death
var locations = []
var dead
var music
var player

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

func get_player():
	if not player:
		player = get_node_or_null("Default/Player")
		if not player:
			player = get_node_or_null("Player")
			if not player:
				printerr("can't find player node: ", player)
	return player

func get_music():
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
	# find player node
	player = get_player()
	# find background music 
	music = get_music()
	# set player location
	if locations:
		locations[0] = player.position
		player.position = locations[global.user.location]
	if not respawn_location:
		respawn_location = player.position

var tween
func _process(_delta):

	if global.user.hp <= 0:
		tween = utils.tween_position(player, respawn_location)
		player.disable('dead')
		dead = true
	if dead and global.user.hp < 100:
		global.user.hp += 1
	elif dead and not tween.is_active():
		if reload_on_death:
			get_tree().reload_current_scene()
		else:
			player.enable('dead')
			dead = false
	if reload_on_death and dead and not tween.is_active():
		player.position = respawn_location
		
