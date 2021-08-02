extends CanvasLayer

onready var base = $Base
onready var eyes = $Base/Eyes
onready var icons = $Base/Icons
var active : bool = false

func _ready():
	pass

var ticks = 0
func _process(delta):
	if active:
		if ticks < 10 :
			eyes.frame = 2
		if ticks == 10:
			eyes.frame = 1
		if ticks > 15:
			eyes.visible = false
			icons.visible = true
		else:
			icons.visible = false
			eyes.visible = true
		if ticks < 30:
			ticks += .5
		base.visible = true
	else:
		base.visible = false
		if ticks > 0:
			if ticks == 14:
				ticks = 5
			ticks -= .5
	
func _input(event):
	if event.is_action_pressed("escape"):
		if active:
			active = false
		else:
			active = true
