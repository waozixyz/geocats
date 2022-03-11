extends Control

onready var spotlight = $SpotLight
onready var territories = $Territories

	
func _input(event):
	for territory in territories.get_children():
		if territory.pressed:
			spotlight.position = event.position

