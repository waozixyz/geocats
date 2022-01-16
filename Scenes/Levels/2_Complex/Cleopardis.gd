extends ChatNPC


var nft_id = "Cleopardis"
var request_id : int
var step : int = 0
func _process(delta):
	._process(delta)
	if completed:
		request_id = API.claim_nft(nft_id)
		completed = false
	if request_id:
		API.check_request(request_id)
