extends Control

onready var current_scene = get_tree().get_current_scene()

onready var eyes = $Eyes
onready var system = $System
onready var status_bar = $System/StatusBar
onready var background = $Background

onready var red_button = $RedButton

# different views
onready var main_view = $System/MainView
onready var settings_view = $System/SettingsView

# sound effects
onready var open_sfx = $OpenSFX
onready var close_sfx = $CloseSFX
onready var hover_sfx = $HoverSFX
onready var pressed_sfx = $PressedSFX

var active : bool = false

var old_view
var view : Control
var player
var change_to = ""

#if mouse enters button play sound
func _hover_sound():
	if system.visible and active:
		hover_sfx.play()

func _press_sound():
	if system.visible and active:
		pressed_sfx.play()

# initialize feline
func _ready():
	modulate.a = 0
	geodex = load("res://Scenes/UI/Geodex/Geodex.tscn").instance()
	map = load("res://Scenes/UI/Feline/Map.tscn").instance()
	map.modulate.a = 0

	for child in system.get_children():
		child.visible = false
	view = main_view
	view.visible = true
	status_bar.visible = true
	for system_view in system.get_children():
		for button in system_view.get_children():
			if button is Button or button is TextureButton:
				button.connect("mouse_entered", self, "_hover_sound")
				button.connect("pressed", self, "_press_sound")



func settings():
	_change_view(settings_view)

var map
var temp_hide = []
func _close_map():
	map_tween = utils.tween(map, "fade", 0, .5)
	utils.tween(map.chat, "fade", 0, .5)
	map.last_territory = ""
	current_scene.set_disable("e_interact", "map", false)
	for child in temp_hide:
		child.visible = true
		temp_hide.erase(child)

func _open_map():
	get_parent().add_child(map)
	utils.tween(map, "fade", 1, .5)
	exit()
	for child in current_scene.get_children():
		if child is CanvasLayer:
			for c in child.get_children():
				if c != map and c.visible:
					c.visible = false
					temp_hide.append(c)

	current_scene.set_disable("e_interact", "map")
var geodex
func _open_geodex():
	add_child(geodex)
	exit()

# exit logic
func exit(now = false):
	if view.name == "MainView" or now:
		if active:
			close_sfx.play()
			active = false
			tween = utils.tween(self, "fade", 0, .3)
			current_scene.set_disable("e_interact", "feline", false)
	else:
		_change_view(main_view)
	
# button press functions
func _button_action(label):
	match label:
		"Map":
			_open_map()
		"Geodex":
			_open_geodex()
		"Exit":
			exit()
			global.save_game()
			SceneChanger.change_scene("TitleScreen")



# change view in system
func _change_view(new_view):
	if new_view != view:
		# update old view
		old_view = view
		utils.tween(old_view, "fade", 0, .2)
		# change current view
		view = new_view
		view.visible = true
		view.modulate.a = 0
		# show current view
		utils.tween(view, "fade", 1, .2)

# change system theme
func _change_color():
	var color = Color(1, 1, 1)
	if press_timer < 29:
		color = Color(rand_range(0, 1), rand_range(0, 1), rand_range(0, 1))
	system.modulate = color
	background.modulate = color
	pressed_sfx.play()
## update logic
var ticks = 0
var press_timer = 0
var red_pressed
var tween
func _process(delta):
	visible = true if modulate.a > 0 else false

	var dfps = delta * global.fps
	if old_view is Control and old_view.modulate.a == 0:
		old_view.visible = false
	# red button press logic
	if modulate.a > 0:
		if red_button.pressed:
			red_pressed = true
			press_timer += dfps
			if press_timer >= 30:
				_change_color()
				red_button.pressed = false
		elif red_pressed:
			_change_color()
			press_timer = 0
			red_pressed = false
	
	# check if visible and disable/ enable player
	if player:
		if modulate.a > 0:
			player.disable("feline")
		else:
			player.enable("feline")
	
	# eye animations
	if ticks < 16:
		eyes.visible = true
		if ticks < 10 :
			eyes.frame = 2
		elif ticks < 13:
			eyes.frame = 1
	else:
		eyes.visible = false
		
	if active:
		## make device visible
		if ticks >= 15:
			if not system.visible:
				system.modulate.a = 0
				utils.tween(system, "fade", 1, .5)
			
			system.visible = true
		else:
			system.visible = false


		if ticks < 16:
			ticks += .3 * dfps
	elif ticks > 0:
		ticks -= .5 * dfps
		system.modulate.a -= .1 * dfps
	if map.modulate.a == 0 and map_tween and not map_tween.is_active():
		get_parent().remove_child(map)
		map_tween = null
	visible = true if modulate.a > 0 else false
var map_tween
func _input(event):
	if event.is_action_pressed("escape") and not current_scene.is_disabled("feline"):
		if active and (tween and not tween.is_active() or not tween):
			exit()

		else:
			if map.modulate.a > 0 and not utils.is_active(map_tween):
				_close_map()
			elif not utils.is_active(tween):
				current_scene.set_disable("e_interact", "feline")
				active = true
				tween = utils.tween(self, "fade", 1, 1)
				open_sfx.play()
	if modulate.a > 0 and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if not event.pressed and system.visible :
				# main view system buttons
				for button in view.get_children():
					if button is Button and button.pressed:
						_button_action(button.name)
