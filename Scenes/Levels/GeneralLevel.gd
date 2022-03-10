extends Node2D
class_name GeneralLevel

export(NodePath) var player 
export(NodePath) var music
export(Vector2) var respawn_location
export(Array, Vector2) onready var locations 
export(bool) var reload_on_death
var dead
func get_player():
	if not player:
		player = get_node_or_null(player)
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
		
