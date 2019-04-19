extends Container
var pause = false

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	var escape	= Input.is_action_just_pressed("ui_cancel")
	if escape:
		_pause()
		rpc_unreliable("_pause")

remote func _pause():
	if not pause:
		get_tree().paused = true
		pause = true
		self.show()
	elif pause:
		get_tree().paused = false
		pause = false
		self.hide()


remote func _on_Retry_Button_button_down(sent=false):
	if not sent:
		rpc_unreliable("_on_Retry_Button_button_down",true)
	get_tree().paused = false
	get_tree().change_scene("res://Engine/INPROGRESSDUNGEON.tscn")
	pass # replace with function body

remote func _on_mainMenuButton_button_down(sent=false):
	if not sent:
		rpc_unreliable("_on_mainMenuButton_button_down",true)
	get_tree().paused = false
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass # replace with function body


remote func _on_quitButton_button_down(sent=false):
	if not sent:
		rpc_unreliable("_on_quitButton_button_down",true)
	get_tree().quit()
	pass # replace with function body


func _on_optionsMenu_button_down():
	pass # replace with function body
