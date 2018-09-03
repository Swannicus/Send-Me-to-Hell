extends Node
var randomseed
var character1 = 0
var localPlayer = 0
var charDict ={}
var playersdict ={}
var music
var wallArray = []
var wallArray2 = []
var NW = 1
var N = 1
var NE = 2
var W = 2
var E = 4
var SW = 4
var S = 8
var SE = 8
func _ready():
	randomize()
	randomseed = randi()
	print(str(randomseed))
	music = load("res://music/Menu Music.wav")
	$audio.set_stream(music)
	$audio.play(0)
	wallArraySetter()

func wallArraySetter():
	wallArray.resize(16)
	wallArray[0] = -1
	wallArray[1] = 1
	wallArray[2] = 3
	wallArray[3] = 0
	wallArray[4] = 18
	wallArray[5] = 2
	wallArray[6] = 17
	wallArray[7] = 8
	wallArray[8] = 5
	wallArray[9] = 16
	wallArray[10] = 4
	wallArray[11] = 7
	wallArray[12] = 6
	wallArray[13] = 9
	wallArray[14] = 15
	wallArray[15] = 12