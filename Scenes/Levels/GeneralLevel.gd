extends Node2D
class_name GeneralLevel

onready var player = $Default/Player

export(Array, Vector2) onready var locations 

func _ready():
	if locations:
		locations[0] = player.position

		player.position = locations[global.user.location]

