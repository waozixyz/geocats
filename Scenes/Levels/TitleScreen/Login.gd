extends Control

onready var play_button = $PlayButton
onready var exit_button = $ExitButton

func _ready():
	# connect buttons
	var err = play_button.connect("pressed", self, "_play_pressed")
	assert(err == OK)
	err = exit_button.connect("pressed", self, "_exit_pressed")
	assert(err == OK)


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
		SceneChanger.change_scene("res://Scenes/City/CatsCradle.tscn")
