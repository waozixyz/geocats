extends Node2D


onready var chat_npc = $Area2D


# Called when the node enters the scene tree for the first time.
func _process(_delta):
	if PROGRESS.variables.get('DesertOutpostUnlocked'):
		visible = false
		chat_npc.disabled = true
		
