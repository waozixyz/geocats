extends Control

onready var eyes = $Eyes
onready var system = $System
onready var status_bar = $System/StatusBar

onready var tween = $Tween
onready var news = $System/StatusBar/News


var master_sound = AudioServer.get_bus_index("Master")
var active : bool = false

var player
func _ready():
	var default = get_parent().get_parent()
	if default and default.has_node("Player"):
		player = default.get_node("Player")
	news.text += "  " # make sure there is enough space for scrolling text

# fading effect
func _tween(obj, start, end, time = .5):
	tween.interpolate_property(obj, "modulate:a", start, end, time, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

# scrolling text function
func _scroll_news():
	var i = 0
	while i < news.text.length():
		var j = i + 1
		if j == news.text.length():
			j = 0

		var next = news.text[j]
		if i == 0:
			news.text[news.text.length() - 1] = news.text[0]
		news.text[i] = next
		i += 1

# exit logic
func _exit():
	active = false
	_tween(self, 1, 0)

# button press functions
func _button_action(label):
	match label:
		"Map":
			pass
		"Home":
			pass
		"Return":
			SceneChanger.change_scene("TitleScreen")
		"Exit":
			_exit()
		"Music":
			pass
		"Sound":
			pass


## update logic
var ticks = 0
var last_visible = false
var news_tick = 0
func _process(delta):
	if system.visible :
		# top bar news scrolling
		news_tick += 1 * delta * global.fps
		if int(news_tick) % 10 == 0:
			_scroll_news()
		
		# main system buttons
		for button in system.get_children():
			if button is Button and button.pressed:
				_button_action(button.name)
		
		# status bar buttons
		for button in status_bar.get_children():
			if button is TextureButton and button.pressed:
				_button_action(button.name)
		
	if last_visible != visible:
		if visible:
			if player:
				player.disable()
		else:
			if player:
				player.enable()
	
		last_visible = visible
	
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
			ticks += .3 * delta * global.fps
		visible = true
	else:
		# start shutdown and hide feline
		if not tween.is_active() and ticks <= 0:
			visible = false

		if ticks > 0:
			ticks -= .5 * delta * global.fps
			system.modulate.a -= .1 * delta * global.fps

func _input(event):
	if event.is_action_pressed("escape"):
		if active:
			_exit()
		else:
			active = true
			_tween(self, 0, 1, 1)

