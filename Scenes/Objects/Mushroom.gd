extends Node2D
class_name Mushroom

onready var sprite = $AnimatedSprite

var touching = false
var depleted = false
var total_frames
export var regen_time = 20
var regen_timer = 0
export var speed = 1.0
export var jump_multiplier = 1.4

func _ready():
	sprite.frame = 0
	sprite.speed_scale = speed
	total_frames = sprite.get_sprite_frames().get_frame_count("default") - 1
	
func set_color(val):
	sprite.modulate.r = val
	sprite.modulate.g = val
	sprite.modulate.b = val

func _process(_delta):
	if touching and not sprite.playing:
		sprite.playing = true
	
	var frame = sprite.frame
	set_color(1 - .08 * frame)
	if depleted and not touching:
		regen_timer += 1
		if regen_timer >= regen_time * .5:
			sprite.frame = 1
			if regen_timer >= regen_time:
				sprite.frame = 0
				depleted = false
				regen_timer = 0
	else:
		if frame == total_frames:
			depleted = true
			sprite.playing = false
	
