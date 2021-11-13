extends InteractSimple


func _ready():
	nft_possible = true
	nft_id = "GeoCache"
	._ready()

func _process(delta):
	._process(delta)
	if do_something:
		nft.reward(nft_id)
		do_something = false
