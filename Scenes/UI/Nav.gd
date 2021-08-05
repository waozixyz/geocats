extends Feline

# feline map
onready var feline_map = get_parent().get_node("FelineMap")
onready var player =  get_parent().get_parent().get_node("Player")
onready var device = $Base/Icons
onready var base = $Base
onready var eyes = $Base/Eyes

var active : bool = false

func _ready():

	_unselect_others(device)
	device.get_node("Map").selected = true

func _action(child):
	if child.name == "Exit":
		active = false
	if child.name == "Map":
		feline_map.visible = true
		active = false
		base.visible = false
		player.disabled = true

func _check(child):
	var rect = child.get_node("ColorRect")
	var area = child.get_node("Area2D")

	if child.pressed:
		child.pressed = false
		_action(child)

	if child.hovered:
		_unselect_others(device)
		child.selected = true
		
	if child.selected:
		rect.visible = true
	else:
		rect.visible = false

var ticks = 0
var last_visible = false
func _process(delta):
	if last_visible != base.visible:
		if base.visible:
			if player:
				player.disabled = true
		else:
			if player:
				player.disabled = false
	
		last_visible = base.visible
	
	if active:
		if ticks < 10 :
			eyes.frame = 2
		if ticks == 10:
			eyes.frame = 1
		## make device visible
		if ticks > 15:
			eyes.visible = false
			device.visible = true
			
			# exit button
			for child in device.get_children():
				_check(child)

		else:
			device.visible = false
			eyes.visible = true

		if ticks < 30:
			ticks += .5
		base.visible = true
	else:
		# start shutdown and hide feline
		base.visible = false
		if ticks > 0:
			if ticks == 14:
				ticks = 5
			ticks -= .5

func _input(event):
	if active:
		input(device, event)

	if event.is_action_pressed("escape"):
		if active:
			active = false
		else:
			active = true
