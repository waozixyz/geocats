extends TextureButton

onready var geodex = get_tree().get_current_scene()
onready var label = $Label

func _on_EntryTemplate_mouse_entered():
	label.rect_position.x -= 10

func _on_EntryTemplate_mouse_exited():
	label.rect_position.x += 10

func _on_EntryTemplate_pressed():
	geodex.activate_entry(label.text)
