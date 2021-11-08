extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var note_list = $Note_List

# Called when the node enters the scene tree for the first time.
func _ready():
	note_list.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
