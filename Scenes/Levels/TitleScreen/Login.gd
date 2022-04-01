extends Control

onready var info_box = get_parent().get_node("InfoBox")
onready var play_button = $PlayButton
onready var exit_button = $ExitButton
onready var info_button = $InfoButton

func _ready():
	# connect buttons
	var err = play_button.connect("pressed", self, "_play_pressed")
	assert(err == OK)
	err = exit_button.connect("pressed", self, "_exit_pressed")
	assert(err == OK)
	err = info_button.connect("pressed", self, "_info_pressed")
	assert(err == OK)

func _info_pressed():
	info_box.visible = true

func _exit_pressed():
	visible = false

func _input(event):
	if event.is_action_pressed("enter"):
		_play_pressed()
	
	if event.is_action_pressed("escape") and get_parent().name == "TitleScreen":
		get_tree().quit()

func _play_pressed():
	_next()

func _next():
	if get_parent().name == "TitleScreen":
		if global.user.current_territory.empty():
			SceneChanger.change_scene("GeoCity", "CatsCradle")
		else:
			SceneChanger.change_scene(global.user.current_territory, global.user.current_level)
