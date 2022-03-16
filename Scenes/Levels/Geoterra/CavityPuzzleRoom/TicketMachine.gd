extends Control

onready var current_scene = get_tree().get_current_scene()
onready var camera = current_scene.camera
onready var sprite = $AnimatedSprite
onready var plus = $Plus
onready var minus = $Minus
onready var enter = $Enter

onready var ticket = $Ticket
onready var pull_ticket = $PullTicket

var frame = 0

var total_frames = 10
var completed
func _ready():

	#hide_interact = false
	var err = plus.connect("pressed", self, "_plus_pressed")
	assert(err == OK)
	err = minus.connect("pressed", self, "_minus_pressed")
	assert(err == OK)
	err = enter.connect("pressed", self, "_enter_pressed")
	assert(err == OK)
	err = ticket.connect("pressed", self, "_ticket_pressed")
	assert(err == OK)
	err = pull_ticket.connect("pressed", self, "_pull_ticket")
	assert(err == OK)
	completed = PROGRESS.variables.get("CavityPuzzleTicketPrinted")
	ticket.visible = true if completed else false
	if completed:
		minus.disabled = true
		plus.disabled = true
		enter.disabled = true
		sprite.frame = 13
func _pull_ticket():
	pass

func _ticket_pressed():
	if ticket_print_done:
		#OS.shell_open("https://geocats.net/ground-cat-conservatory-web-portal/")
		pass


func _plus_pressed():
	if sprite.frame < 11:
		frame += 1
		if frame > total_frames - 1:
			frame = 0
		sprite.frame = frame
	#	sprite.frame = frame
	

func _minus_pressed():
	if sprite.frame < 11:
		frame -= 1
		if frame < 0:
			frame = total_frames - 1
		sprite.frame = frame
	#	sprite.frame = frame

var success
var failed
func _enter_pressed():
	last_frame = frame
	if frame == 9:
		success = true
	else:
		failed = true

var ticks = 0
var print_ticket
var ticket_print_done
var last_frame
func _process(delta):
	if modulate.a > 0 and camera.zoom.x == 1:
		utils.tween(camera, "zoom", Vector2(1.4, 1.4), .5)
	if modulate.a < 1 and camera.zoom.x > 1.3:
		utils.tween(camera, "zoom", Vector2(1, 1), .5)
		
	if success:
		sprite.frame = 12
		ticks += 1
		if ticks > 30:
			ticks = 0
			success = false
			print_ticket = true
			AudioManager.play_sound("res://Assets/Levels/Geoterra/CavityPuzzleRoom/completed.ogg")
			minus.disabled = true
			plus.disabled = true
			enter.disabled = true
	if failed:
		sprite.frame = 11
		ticks += 1
		if ticks > 30:
			ticks = 0
			failed = false
			sprite.frame = last_frame
	
	if print_ticket and not ticket_print_done:
		ticks += 1
		if sprite.frame < 17:
			if ticks % 15 == 0:
				ticks = 0
				sprite.frame += 1
		elif ticks % 30 == 0:
			ticket_printed()
	

func ticket_printed():
	#nft.reward(nft_id)
	ticket.visible = true

	ticket_print_done = true
	PROGRESS.variables["CavityPuzzleTicketPrinted"] = true
