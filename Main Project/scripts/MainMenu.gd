extends MarginContainer

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	var music = get_node("/root/Globals/audio")
	music.stream = load("res://music/Menu Music.wav")
	music.play(0)
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
