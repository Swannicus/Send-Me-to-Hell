extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	Globals.music.stream = load("res://music/Menu Music.wav")
	Globals.music.play(0)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_exit_button_up():
	get_tree().quit()
	pass


func _on_options_button_up():
	sceneTransition("optionsscene")
	pass


func _on_start_button_up():
	sceneTransition("res://Scenes/CharacterSelect.tscn")
	pass

func sceneTransition(scenePath):
	var fader = $fader/anim
	#fader
	get_tree().change_scene(scenePath)
	pass