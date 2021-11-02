extends InteractSimple

onready var pumpkin = get_tree().get_current_scene().get_node("CanvasLayer/PUMPKIN")
# onready var nft = get_tree().get_current_scene().get_node("Default/NFT")

onready var pumpkin_ui = pumpkin.get_node("Giant_Pumpkin_UI")


#For Loop
var btns = []

onready var congratulations = pumpkin.get_node("Congratulations")

var success : bool = false
var failed : bool = false
var correct_guess : bool = false
var correct_guess_done : bool = false
var nft_id_pumpkin : String = "GiantPumpkin"

func _ready():
	for child in pumpkin_ui.get_children():
		print(child.name)

func open_keyboard():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		pumpkin_ui.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		pumpkin_ui.visible = false
		nft.main.visible = false

# Here we can log the order of buttons pressed? 
var keyboard_array = []
func keyboard_action():
	for child in pumpkin_ui.get_children():
		print(child.name)

# This would be the place to check if the sequence is correct?
func enter_action():
	if keyboard_array == global.pumpkin_code:
		success = true
	else:
		failed = true
		
func check_button(button):
	if button.pressed and not correct_guess:
		if not failed and not success:
			if button.name == "Note_1":
				keyboard_action()
		button.pressed = false
	if button.get_node("Sprite").visible:
		if keyboard_array > 7:
			print("Play an error noise and reset array?")
			keyboard_array.clear()

func guessed_correctly():
	nft.reward(nft_id_pumpkin)
	congratulations.get_node("Sprite").visible = true
	congratulations.get_node("Label").visible = true
	print("Change Pumpkin animation to happy")
	correct_guess_done = true
	
func _process(delta):
	if do_something:
		get_parent().creepy_city()
		do_something  = false
		open_keyboard()
		disabled = true
		nft.update(pumpkin.visible, nft_id_pumpkin)
	#	if pumpkin.visible:
	#		check_button(one_button)
		if not failed and not success and not correct_guess:
			if keyboard_array.length > 7:
				 keyboard_array.clear
		if failed:
			failed = false
		if success:
			success = false
			correct_guess = true
		if correct_guess and not correct_guess_done:
			# No idea about this stuff #
			guessed_correctly()
		if correct_guess_done:
			print("Wasssssup")

func _pumpkin_code(event):
	if pumpkin.visible:
		if keyboard_array == 7 and keyboard_array == global.pumpkin_code:
			guessed_correctly()

		elif not correct_guess:
			if not failed and not success:
				if Input.is_action_just_pressed():
					for child in pumpkin_ui.get_children():
						keyboard_action()
