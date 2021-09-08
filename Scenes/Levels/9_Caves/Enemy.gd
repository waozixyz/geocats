extends StaticBody2D

onready var sprite = $Body
onready var eye_left = $EyeLeft
onready var eye_right = $EyeRight

var bullets = []

func _eyes(active):
	eye_left.frame = 0
	eye_right.frame = 0
	eye_left.visible = active
	eye_right.visible = active
	eye_left.playing = active
	eye_right.playing = active

	
func _shoot(x, y):
	var ball_lazer = Sprite.new()
	ball_lazer.texture = load("res://Assets/Agents/NornaWyrd/ball_lazer.png")
	ball_lazer.hframes = 4
	ball_lazer.frame = 2
	ball_lazer.position = Vector2(x, y)
	add_child(ball_lazer)
	bullets.append(ball_lazer)

func _process(delta):
	for bullet in bullets:
		bullet.position.x -= 1
		bullet.position.y -= 1
		bullet.rotation_degrees -= 5

var making_beam = false
var beam_ticker = 0
func make_beam():
	if beam_ticker == 0:
		_eyes(true)
	if beam_ticker == 160:
		_shoot(-28, 4)
		_shoot(-12, 4)
	if beam_ticker == 180:
		_eyes(false)
	beam_ticker+=1


