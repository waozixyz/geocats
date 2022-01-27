extends ChatNPC


var nft_id = "Cleopardis"
var request_id 
func _process(delta):
	._process(delta)
	if completed:
		request_id = Deta.claim_nft(nft_id)
		completed = false
	if request_id:
		var response = Deta.check_request(request_id)
		if response:
			print(response)
			request_id = null
