extends Control

onready var btn = $Button
onready var label = $Label

var texture_path = "res://Assets/UI/Feline/MapView/"
var current = "CatsCradle"
func _ready():
	btn.texture_normal = load(texture_path + current + '.png')
	label.text = _get_label_name()
	
func _get_label_name():
	var rtn = "\""
	match current:
		"CatsCradle": rtn += "Cat's Cradel"
		"Complex": rtn += "NONACO Housing Project #420"
		"GeoCity": rtn += "GeoCity"
		"Creek": rtn += "Canopy Creek"
		"Litterbox": rtn += "The Great Litterbox"
		"Lodge": rtn += "GeoLodge"
	rtn += "\""
	return rtn
