extends Area2D

onready var letter = get_tree().get_current_scene().get_node("CanvasLayer/Letter")
onready var interact_with = get_tree().get_current_scene().get_node("CanvasLayer/InteractWith")
onready var sprite = $Sprite
var touching = false

func _ready():
	set_process_input(true)
	assert(connect("body_entered", self, "_on_body_entered") == 0)
	assert(connect("body_exited", self, "_on_body_exited") == 0)
	if not global.data.present:
		sprite.visible = false
	
func _on_body_entered(body):

	if body.name == "Player":
		touching = true
		if sprite.visible:
			interact_with.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		touching = false
		interact_with.visible = false

func _input(_event):
	# when i press the interact key (e)
	if Input.is_action_just_pressed("interact"):
		# if the letter is visible and the present is not visible
		if letter.visible and sprite.visible == false:
			interact_with.visible = false
			letter.visible = false
		# if im touching the present and the present is visible
		if touching and sprite.visible:
			AudioStreamManager.play("res://Assets/Sfx/SFX/Wood_Door_Latch_Open_2.ogg")
			letter.visible = true
			visible = false
			global.data.present = false


