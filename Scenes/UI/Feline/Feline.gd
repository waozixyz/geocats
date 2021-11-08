extends Control

onready var eyes = $Eyes
onready var system = $System
onready var status_bar = $System/StatusBar
onready var background = $Background

onready var tween = $Tween

onready var red_button = $RedButton

# different views
onready var main_view = $System/MainView
onready var map_view = $System/MapView
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
	hover_sfx.play()

func _press_sound():
	pressed_sfx.play()

# initialize feline
func _ready():
	var default = get_parent().get_parent()
	if default and default.has_node("Player"):
		player = default.get_node("Player")
	
	for child in system.get_children():
		child.visible = false
	view = main_view
	view.visible = true
	status_bar.visible = true
	for view in system.get_children():
		for button in view.get_children():
			if button is Button or button is TextureButton:
				button.connect("mouse_entered", self, "_hover_sound")
				button.connect("pressed", self, "_press_sound")
# fading effect
func _tween(obj, start, end, time = .5):
	tween.interpolate_property(obj, "modulate:a", start, end, time, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

func settings():
	_change_view(settings_view)

# exit logic
func exit():
	if view.name == "MainView":
		if active:
			close_sfx.play()
			active = false
			_tween(self, 1, 0, 1)

	else:
		_change_view(main_view)
	
# button press functions
func _button_action(label):
	match label:
		"Map":
			_change_view(map_view)
		"Home":
			pass
		"Exit":
			exit()
			if OS.get_name() == "HTML5":
				change_to = "TitleScreen"
			else:
				Data.saveit()
				get_tree().quit()


# change view in system
func _change_view(new_view):
	# hide current view
	_tween(view, 1, 0, .2)
	# update old view
	old_view = view
	# change current view
	view = new_view
	view.visible = true
	# show current view
	_tween(view, 0, 1, .2)

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
var last_visible = false
var press_timer = 0
var red_pressed
func _process(delta):
	var dfps = delta * global.fps
	if old_view is Control and old_view.modulate.a == 0:
		old_view.visible = false
	# red button press logic
	if visible:
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
	if last_visible != visible:
		if visible:
			if player:
				player.disable()
		else:
			if player:
				player.enable()
	
		last_visible = visible
	
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
				_tween(system, 0, 1)
			
			system.visible = true
		else:
			system.visible = false


		if ticks < 16:
			ticks += .3 * dfps
		visible = true
	else:
		# start shutdown and hide feline
		if not tween.is_active() and ticks <= 0:
			visible = false
			if change_to:
				SceneChanger.change_scene(change_to)
			
		if ticks > 0:
			ticks -= .5 * dfps
			system.modulate.a -= .1 * dfps


func _input(event):
	if event.is_action_pressed("escape"):
		if active:
			exit()
		else:
			active = true
			_tween(self, 0, 1, 1)
			open_sfx.play()
	if visible and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				pass
			else:
				# release
				if system.visible :
					# main view system buttons
					for button in view.get_children():
						if button is Button and button.pressed:
							_button_action(button.name)
