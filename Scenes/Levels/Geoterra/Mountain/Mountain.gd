extends GeneralLevel


onready var stars = $BelowPlayer/Stars

func _ready():
	PROGRESS.variables["GeoLodgeUnlocked"] = true
	._ready()

func _process(delta):
	stars.material.set_shader_param('global_transform', get_global_transform() );

