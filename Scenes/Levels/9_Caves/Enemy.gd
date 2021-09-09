extends StaticBody2D

onready var sprite = $Body
onready var eye_left = $EyeLeft
onready var eye_right = $EyeRight
onready var boulder = get_parent().get_node("Boulder")

var bullets = []
var tween = Tween.new()
func _ready():
	add_child(tween)
	
func _eyes(active):
	eye_left.frame = 0
	eye_right.frame = 0
	eye_left.visible = active
	eye_right.visible = active
	eye_left.playing = active
	eye_right.playing = active


func _shoot(shape, start, end):
	var bullet = Sprite.new()
	bullet.texture = load("res://Assets/Agents/NornaWyrd/" + shape + ".png")
	bullet.hframes = 4
	bullet.frame = 2
	bullet.scale = Vector2(3, 3)
	bullet.position = start

	get_parent().add_child(bullet)
	bullets.append(bullet)
	tween.interpolate_property(bullet, "position", start, end, 3, Tween.TRANS_LINEAR, Tween.TRANS_LINEAR)
	tween.start()

func _process(_delta):
	for i in range(bullets.size()):
		if range(bullets.size()).has(i):
			var bullet = bullets[i]
			bullet.rotation_degrees -= 5
			if not tween.is_active():
				bullets.remove(i)
				get_parent().remove_child(bullet)


				
var making_beam = false
var beam_ticker = 0
func make_beam():
	var pos = position
	if beam_ticker == 0:
		_eyes(true)
	elif beam_ticker == 160:
		_shoot("ball_lazer", pos + Vector2(-108, 10), boulder.position)
		_shoot("ball_lazer", pos + Vector2(-55, 10), boulder.position)
		making_beam = true
	elif beam_ticker == 180:
		_eyes(false)
	if beam_ticker <= 200:
		beam_ticker+=1
	if making_beam and not tween.is_active():
		making_beam = false
		return true

