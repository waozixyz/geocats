extends Control

onready var news = $News


func _ready():
	news.text += "  " # make sure there is enough space for scrolling text

# scrolling text function
func _scroll_news():
	var i = 0
	while i < news.text.length():
		var j = i + 1
		if j == news.text.length():
			j = 0

		var next = news.text[j]
		if i == 0:
			news.text[news.text.length() - 1] = news.text[0]
		news.text[i] = next
		i += 1

var news_tick = 0
func _process(delta):
	if get_parent().visible:
		# top bar news scrolling
		if int(news_tick) % 10 == 0:
			_scroll_news()
		news_tick += delta * global.fps

# button press functions
func _button_action(label):
	match label:
		"Exit":
			get_parent().get_parent().exit()
		"Music":
			pass
		"Sound":
			pass


func _input(event):
	if get_parent().visible and visible and event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				pass
			else:
				# status bar buttons
				for button in get_children():
					if button is TextureButton and button.pressed:
						_button_action(button.name)
