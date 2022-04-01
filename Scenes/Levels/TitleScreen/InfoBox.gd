extends Panel

onready var close_button = $Taskbar/Exit
# Called when the node enters the scene tree for the first time.
func _ready():
	var err = close_button.connect("pressed", self, "_close_pressed")
	assert(err == OK)
	if PROGRESS.variables.has("title_screen_viewed") and PROGRESS.variables["title_screen_viewed"]:
		visible = false

func _close_pressed():
	PROGRESS.variables["title_screen_viewed"] = true
	visible = false
