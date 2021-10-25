extends Feline

# feline map
onready var feline_map = get_parent().get_node("FelineMap")
onready var device = $Icons
onready var eyes = $Eyes
onready var mute_sprite = $Icons/Mute/Sprite
onready var music_sprite = $Icons/Music/Sprite
onready var exit_sprite = $Icons/Exit/Sprite

var master_sound = AudioServer.get_bus_index("Master")
var active : bool = false

var player
func _ready():
	var default = get_parent().get_parent()
	if default and default.has_node("Player"):
		player = default.get_node("Player")
	_unselect_others(device)
	device.get_node("Map").selected = true

func _action(child):
	if child.name == "Exit":
		exit_sprite.frame = 1
		active = false
	if child.name == "Location":
		visible = false
		SceneChanger.change_scene("TitleScreen", 0, "", 1)
	if child.name == "Return":
		active = false
		Data.saveit()
		get_tree().quit()
	if child.name == "Map":
		if feline_map:
			feline_map.visible = true
		active = false
		visible = false
		if player:
			player.disable()
	if child.name == "Mute":
		if mute_sprite.frame == 0:
			AudioServer.set_bus_mute(master_sound, true)
			mute_sprite.frame = 1
	else:
		AudioServer.set_bus_mute(master_sound, false)
		mute_sprite.frame = 0
	if child.name == "Music":
		AudioServer.set_bus_mute(master_sound, true)
		music_sprite.frame = 1
		

func _check(child):
	var rect = child.get_node("ColorRect")

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
func _process(_delta):
	if last_visible != visible:
		if visible:
			if player:
				player.disable()
		else:
			if player:
				player.enable()
	
		last_visible = visible
	
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
		visible = true
	else:
		# start shutdown and hide feline
		visible = false
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
