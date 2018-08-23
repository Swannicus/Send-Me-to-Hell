extends Node
var randomseed
var character1 = 0
var localPlayer = 0
var charDict ={}
var playersdict ={}
var music
func _ready():
	randomize()
	randomseed = randi()
	print(str(randomseed))
	music = load("res://music/Menu Music.wav")
	$audio.set_stream(music)
	$audio.play(0)