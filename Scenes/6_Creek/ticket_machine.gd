extends Area2D

onready var hud = get_tree().get_current_scene().get_node("CanvasLayer/HUD")


onready var machine_ui = hud.get_node("Machine")
onready var machine_gm = get_tree().get_current_scene().get_node("BelowPlayer/Viewport/Machine")

onready var plus_button = hud.get_node("Plus")
onready var minus_button = hud.get_node("Minus")
onready var enter_button = hud.get_node("Enter")
onready var ticket = hud.get_node("Ticket")

var number: int = 0;
var success : bool = false
var failed : bool = false
var print_ticket : bool = false
func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
func _on_body_entered(body):
	if body.name == "Player":
		hud.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		hud.visible = false
		
var ticks: int = 0

func check_button(button):
	if button.visible:
		ticks += 1
		if ticks > 10:
			button.visible = false
			ticks = 0

func _process(delta):
	check_button(plus_button)
	check_button(minus_button)
	check_button(enter_button)
	if not failed and not success and not print_ticket:
		if number > 10:
			number = 0
		if number < 0:
			number = 10
		machine_ui.frame = number
		machine_gm.frame = number
	if failed:
		machine_ui.frame = 11
		ticks += 1
		if ticks > 30:
			ticks = 0
			failed = false
	if success:
		machine_ui.frame = 12
		ticks += 1
		if ticks > 30:
			ticks = 0
			success = false
			print_ticket = true
	if print_ticket and machine_ui.frame < 17:
		ticks += 1
		if ticks % 15 == 0:
			machine_ui.frame = machine_ui.frame + 1
	
func _input(event):
	if hud.visible:
		if Input.is_action_just_pressed("enter") and machine_ui.frame == 17:
			ticket.visible = true
		elif not print_ticket:
			if not failed and not success:
				if Input.is_action_just_pressed("plus"):
					number += 1
					plus_button.visible = true
				if Input.is_action_just_pressed("minus"):
					number -= 1
					minus_button.visible = true
			if Input.is_action_just_pressed("enter"):
				enter_button.visible = true
				if number == 9:
					success = true
				else:
					failed = true
