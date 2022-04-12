extends Control

onready var splash = $AnimatedSprite
onready var audio = $AudioStreamPlayer

var particles
var loaded

func _ready():
#	if utils.get_season() == "Winter":
#		particles = utils.get_particle(utils.Particle.Snow)
#		particles.preprocess = false
	utils.tween(splash, "fade", 1)
	if particles:
		add_child(particles)
	loaded = true


func _next():
	SceneChanger.change_scene("TitleScreen")
	if particles:
		remove_child(particles)


func _process(_delta):
	if splash.frame == 77:
		_next()
	if loaded:
		splash.play()
		audio.play()
		loaded = false

func _input(event):
	if event.is_action_pressed("escape") or event.is_action_pressed("interact") or event.is_action_pressed("jump"):
		_next()
