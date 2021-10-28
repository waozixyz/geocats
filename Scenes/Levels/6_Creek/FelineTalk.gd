extends Area2D

onready var chat_with = get_tree().get_current_scene().get_node("Default/CanvasLayer/ChatWith")
onready var player =  get_tree().get_current_scene().get_node("Default/Player")


func _ready():
	connect("body_entered", self, "_on_body_entered")

var started : bool = false

func _on_body_entered(body):
	if body.name  == "Player" and not "feline_creek" in PROGRESS.dialogues:
		started = true
		chat_with.start("feline_creek", true)
		player.disable()
		chat_with.visible = true
		PROGRESS.dialogues.feline_creek = true
	
func _process(_delta):
	if started and not chat_with.started:
		player.enable()
