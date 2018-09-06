extends Container

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Retry_pressed():
	get_tree().change_scene("res://Engine/dungeon1_mapgen.tscn")
	pass # replace with function body


func _on_Main_Menu_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	var music = get_node("/root/Globals/audio")
	music.stream = load("res://music/Menu Music.wav")
	music.play(0)
	pass # replace with function body
