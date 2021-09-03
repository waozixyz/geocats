extends Area2D
class_name InteractMain

onready var player =  get_tree().get_current_scene().get_node("Default/Player")
onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var nft = get_tree().get_current_scene().get_node("Default/NFT")

var touching : bool= false
var nft_possible: bool = false
var nft_id : String = ""
var object
var play_audio : bool = false
var disabled = false

func _ready():
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")


func _on_body_entered(body):
	if body.name == "Player" and not disabled:
		object.visible = true
		touching = true

func _on_body_exited(body):
	if body.name == "Player":
		object.visible = false
		touching = false
		if nft_possible:
			nft.main.visible = false
			chat_with.visible = false
func _process(_delta):
	if play_audio:
		if playing.has(name) and touching and playing[name].directional:
			object.visible = false
			if playing[name].audio.volume_db < 0:
				playing[name].audio.volume_db += .1
		elif touching:
			object.visible = true
		elif playing.has(name) and playing[name].directional:
			playing[name].audio.volume_db -= 0.1
			if playing[name].audio.volume_db < -9:
				_stop_playing(playing[name].audio)

func _add_audio(path, file_name, directional = true):
	if not playing.has(file_name):
		var audio
		if directional:
			audio = AudioStreamPlayer2D.new()
		else:
			audio = AudioStreamPlayer.new()
		add_child(audio)
		audio.stream = load("res://Assets/Sfx/" + path + "/" + file_name + ".ogg")
		if audio.stream != null:
			play_audio = true
			audio.connect("finished", self, "_stop_playing", [audio])
			audio.stream.loop = false
			audio.play()
			playing[name] = {
				"audio": audio,
				"flie_name": file_name,
				"directional": directional
			}
		else:
			play_audio = false
			remove_child(audio)
var playing = {}
func _stop_playing(stream):
	playing.erase(name)
	remove_child(stream)
	if touching:
		object.visible = true
		
	
