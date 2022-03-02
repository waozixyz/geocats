extends Node2D
class_name GeneralLevel

export(NodePath) var player 
export(NodePath) var music

export(Array, Vector2) onready var locations 
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

