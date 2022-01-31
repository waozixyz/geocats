extends Node2D

onready var player = $Default/Player

export(Array, Vector2) onready var locations 

func _ready():
	locations[0] = player.position

	player.position = locations[global.user.location]

