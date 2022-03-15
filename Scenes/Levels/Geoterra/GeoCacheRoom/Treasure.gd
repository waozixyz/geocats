extends E_Interact

onready var sprite = $Sprite


func _process(delta):
	._process(delta)
	if dia_started:

		sprite.frame = 1
	if sprite.frame == 1:
		disabled = true
		
