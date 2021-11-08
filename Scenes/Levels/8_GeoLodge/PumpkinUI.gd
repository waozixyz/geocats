extends Node2D


onready var sprite = $AnimatedSprite
onready var notes = $Notes

func _ready():
	sprite.play()
	for note in notes.get_children():
		var sound = note.get_node("Sound")

		sound.set_volume_db(-30)
	print(global.pumpkin_code)
var input_code = ""
func _input(event):
	if visible:
		for note in notes.get_children():
			var spr = note.get_node("Sprite")
			var btn = note.get_node("Button")
			var sound = note.get_node("Sound")
			if btn.is_hovered():
				spr.visible = true
				spr.frame = int(note.name) + 7
			else:
				spr.visible = false
			if event is InputEventMouseButton:
				if event.pressed:
					pass
				else:
					if btn.pressed:
						spr.frame = int(note.name)
						sound.play()
						input_code += note.name
						if input_code.length() == global.pumpkin_code.length():
							if input_code == global.pumpkin_code:
								print("yes")
							else:
								print("no")
							input_code = ""
							

