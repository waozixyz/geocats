extends ChatNPC


var nft_id = "Cleopardis"
var request_id : int
var step : int = 0
func _process(delta):
	._process(delta)
	if step == 0 and completed:
		request_id = API.is_nft_available_db(nft_id)
		step += 1
	if  API.current_request_id == request_id and API.current_response:
		if API.current_response > 0:
			if step == 1:
				request_id = API.is_nft_available_db(nft_id)
				step += 1
			elif step == 2:
				print(API.current_response)
		else:
			step = -1
