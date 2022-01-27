extends InteractSimple

onready var sprite = $AnimatedSprite

onready var hud = get_tree().get_current_scene().get_node("CanvasLayer/HUD")
onready var hud_sprite = hud.get_node("AnimatedSprite")
onready var plus = hud.get_node("Plus")
onready var minus = hud.get_node("Minus")
onready var enter = hud.get_node("Enter")

onready var ticket = hud.get_node("Ticket")
onready var pull_ticket = hud.get_node("PullTicket")

var frame = 0

var total_frames 
var completed
func _ready():
	total_frames = sprite.frames.get_frame_count("default")
	hide_interact = false
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
	
func _pull_ticket():
	pass

func _ticket_pressed():
	if ticket_print_done:
		OS.shell_open("https://geocats.net/ground-cat-conservatory-web-portal/")


func _plus_pressed():
	if hud_sprite.frame < 11:
		frame += 1
		if frame > total_frames - 1:
			frame = 0
		hud_sprite.frame = frame
		sprite.frame = frame
	

func _minus_pressed():
	if hud_sprite.frame < 11:
		frame -= 1
		if frame < 0:
			frame = total_frames - 1
		hud_sprite.frame = frame
		sprite.frame = frame

var success
var failed
func _enter_pressed():
	if frame == 9:
		success = true
	else:
		failed = true

var ticks = 0
var print_ticket
var ticket_print_done
func _process(delta):
	if do_something:
		hud.visible = false if hud.visible else true
		do_something = false
	if not touching:
		hud.visible = false
	if success:
		hud_sprite.frame = 12
		ticks += 1
		if ticks > 30:
			ticks = 0
			success = false
			print_ticket = true

	if failed:
		hud_sprite.frame = 11
		ticks += 1
		if ticks > 30:
			ticks = 0
			failed = false
			hud_sprite.frame = sprite.frame
	
	if print_ticket and not ticket_print_done:
		ticks += 1
		if hud_sprite.frame < 17:
			if ticks % 15 == 0:
				ticks = 0
				hud_sprite.frame = hud_sprite.frame + 1
		elif ticks % 30 == 0:
			ticket_printed()
	

func ticket_printed():
	nft.reward(nft_id)
	ticket.visible = true

	hud_sprite.frame = 0
	sprite.frame = 0
	ticket_print_done = true
	PROGRESS.variables["CavityPuzzleTicketPrinted"] = true
