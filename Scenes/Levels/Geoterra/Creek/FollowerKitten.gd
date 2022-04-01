extends SimpleMovingAI


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():

	if not is_connected("body_entered", self, "_on_body_entered"):
		var err = connect("body_entered", self, "_on_body_entered")
		assert(err == OK) 
	if not is_connected("body_exited", self, "_on_body_exited"):
		var err = connect("body_exited", self, "_on_body_exited")
		assert(err == OK) 
