extends Area2D

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
var touching
onready var sprite = $Sprite

func _on_body_entered(body):
	if body.name == "Player":
		touching = true

func _on_body_exited(body):
	if body.name == "Player":
		touching = false

func _fix_color():
	var color = sprite.modulate
	if color.r > 1:
		color.r -= .5
	sprite.modulate = color

func _process(delta):
	if touching and get_parent().visible:
		var r
		if get_parent().name == "wyrd":
			r = 20
		else:
			r = 5
		sprite.modulate = Color(r, 1, 1)

	
	_fix_color()
