extends Control

onready var splash = $AnimatedSprite

var particles

func _ready():
	if Utils.get_season() == "Winter":
		particles = Utils.get_particle_instance"Snow")
	add_child(particles)

func _next():
	SceneChanger.change_scene("TitleScreen")
	remove_child(particles)

func _process(_delta):
	if splash.frame == 77:
		_next()

func _input(event):
	if event.is_action_pressed("escape") or event.is_action_pressed("interact") or event.is_action_pressed("jump"):
		_next()
