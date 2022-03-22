extends Area2D
class_name AreaInteract


var touching : bool = false
var disabled : bool = false

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
	
