extends Control

onready var play_button = $PlayButton
onready var exit_button = $ExitButton

onready var email = $Email
onready var password = $Password
onready var mistake = $Mistake
onready var nokey = $NoKey
onready var noserver = $NoServer
onready var connecting = $Connecting
onready var login_again = $LoginAgain

func _ready():
	# connect buttons
	var err = play_button.connect("pressed", self, "_login_pressed")
	assert(err == OK)
	err = exit_button.connect("pressed", self, "_exit_pressed")
	assert(err == OK)

	login_again.visible = true if Global.data.login_again else false
	Global.data.login_again = false

func _exit_pressed():
	visible = false

func _input(event):
	if event.is_action_pressed("enter"):
		_login_pressed()
	
	if event.is_action_pressed("escape") and get_parent().name == "TitleScreen":
		get_tree().quit()
	
var request : HTTPRequest
func _login_pressed():
	var body = { "Email": email.text, "Password": password.text}

	connecting.visible = true
	nokey.visible = false
	mistake.visible = false
	noserver.visible = false
	login_again.visible = false
	request = API.get_request("/login", body, null)

func _check_response(response):
	if not response:
		noserver.visible = true
	else:
		noserver.visible = false
		if response.has('status') and response.status:
			if response.has("login"):
				if response["login"]:
					_next()
				else:
					nokey.visible = true	
		else:
			mistake.visible = true

func _process(_delta):
	if request:
		var body_size = request.get_body_size()
		if body_size == -1:
			connecting.visible = true
		elif body_size > 0:
			connecting.visible = false
			_check_response(API.response)

		else:
			connecting.visible = false

	
func _next():
	if get_parent().name == "TitleScreen":
		var scene = Global.user.scene if Global.user.has("scene") else "CatsCradle"
		var location = Global.user.location if Global.user.has("location") else 0
		SceneChanger.change_scene(scene, location)
		print(Global.user)
	else:
		API.repeat_request()
		visible = false
	if request:
		API.remove_child(request)
		request = null

