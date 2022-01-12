extends Area2D
class_name AreaInteract

var touching : bool
var disabled : bool

func _ready():
	if not is_connected("body_entered", self, "_on_body_entered"):
		var err = connect("body_entered", self, "_on_body_entered")
		assert(err == OK) 
	if not is_connected("body_exited", self, "_on_body_exited"):
		var err = connect("body_exited", self, "_on_body_exited")
		assert(err == OK) 

func _on_body_entered(body):
	if body.name == "Player" and not disabled:
		touching = true
func _on_body_exited(body):
	if body.name == "Player":
		touching = false

func _finished_playing(sound):
	remove_child(sound)

func _play_sound(sound_file):
	if sound_file:
		var sound = AudioStreamPlayer.new()

		sound.stream = load(sound_file)

		if sound.stream is AudioStreamOGGVorbis:
			sound.stream.loop = false
		
		sound.bus = "Sound"
		sound.connect("finished", self, "_finished_playing", [sound])
		sound.play()

		add_child(sound)
