extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_EntryTemplate_mouse_entered():
	var label = get_node('Label')
	label.rect_position.x -= 10


func _on_EntryTemplate_mouse_exited():
	var label = get_node('Label')
	label.rect_position.x += 10
	print(label.text)
