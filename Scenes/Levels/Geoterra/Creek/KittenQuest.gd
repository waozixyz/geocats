extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is MovingBody:
			
			print(child.name)

	if not is_connected("body_entered", self, "_on_body_entered"):
		var err = connect("body_entered", self, "_on_body_entered")
		assert(err == OK) 
	if not is_connected("body_exited", self, "_on_body_exited"):
		var err = connect("body_exited", self, "_on_body_exited")
		assert(err == OK) 

func _on_body_entered(body):
	print("enter area: ", body.name)

func _on_body_exited(body):
	print("exit area: ", body.name)
