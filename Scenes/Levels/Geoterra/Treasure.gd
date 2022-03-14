extends ChatNPC

onready var sprite = $Sprite


func _process(delta):
	._process(delta)
	sprite.frame = 1 if dia_started else 0
		
