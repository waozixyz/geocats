extends InteractSimple

onready var pumpkin = get_tree().get_current_scene().get_node("CanvasLayer/PUMPKIN")
onready var note_list = pumpkin.get_node("Note_List")
onready var giant_pumpkin = get_tree().get_current_scene().get_node("GiantPumpkin")
# onready var nft = get_tree().get_current_scene().get_node("Default/NFT")

onready var congratulations = pumpkin.get_node("Congratulations")

var correct_guess : bool = false
var correct_guess_done : bool = false
var nft_id_pumpkin : String = "GiantPumpkin"
var input_string = ""

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")

func _on_body_entered(body):
	if body.name == "Player":
		note_list.visible = true
	
func _on_body_exited(body):
	if body.name == "Player":
		note_list.visible = false
		nft.main.visible = false

func guessed_correctly():
	nft.reward(nft_id_pumpkin)
	congratulations.get_node("Sprite").visible = true
	congratulations.get_node("Label").visible = true
	print("Change Pumpkin animation to happy")
	print("Activate spooky mode")
	
func _process(delta):
	if do_something:
		do_something  = false
		_ready()
		disabled = true
		nft.update(pumpkin.visible, nft_id_pumpkin)
		if input_string == str(global.pumkin_code):
				guessed_correctly()
		if input_string.size > 7:
			input_string = ""
			giant_pumpkin.shake
			print("RESET")

func _input(event):
	if pumpkin.visible:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				for note in note_list.get_children():
					if note.pressed:
						input_string += note.name 
						print(input_string)
						_add_audio("SFX", note.name)
