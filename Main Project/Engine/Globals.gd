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
var monstersInLevelArray =[]
var livingMonsters = 0
var hellpearlBroken = false
enum {PLAYERS,MONSTERS,DESTRUCTIBLES}

class ammo:
	var random = load("res://Engine/randomLib.gd").new()
	var ammoScene = load("res://Scenes/ammo.tscn")
	var ammoType
	var Walls
	func _init(wallParam,seedParam):
		random.setSeed(seedParam)
		Walls = wallParam
	func drop(locationParam,typeParam=0):
		var ammoDrop = ammoScene.instance()
		Walls.add_child(ammoDrop)
		ammoDrop.global_position = locationParam
		if typeParam == 0:
			ammoDrop.settype(random.randRangeInt(4,7))
		else:
			 ammoDrop.settype(typeParam)

class coin:
	var random = preload("res://Engine/randomLib.gd").new()
	var coinScene = preload("res://Scenes/coin.tscn")
	var Walls
	func _init(wallParam,seedParam):
		Walls = wallParam
		random.setSeed(seedParam)
	func drop(locationParam):
		var coinDrop = coinScene.instance()
		Walls.add_child(coinDrop)
		coinDrop.global_position = locationParam
		coinDrop.apply_central_impulse(Vector2(random.randRangeInt(-200,200),random.randRangeInt(-200,200)))

func _ready():
	music = $audio
	music.set_stream(load("res://music/Menu Music.wav"))
	music.play(0)
	wallArraySetter()

func _process(delta):
	#print("monsters"+str(livingMonsters))
	if livingMonsters <= 0 and hellpearlBroken:
		get_tree().change_scene("res://Engine/INPROGRESSDUNGEON.tscn")

func wallArraySetter():
	wallArray.resize(16)
	wallArray[0] = -1
	wallArray[1] = 4
	wallArray[2] = 2
	wallArray[3] = 3
	wallArray[4] = 6
	wallArray[5] = 5
	wallArray[6] = 11
	wallArray[7] = 10
	wallArray[8] = 0
	wallArray[9] = 9
	wallArray[10] = 1
	wallArray[11] = 8
	wallArray[12] = 7
	wallArray[13] = 15
	wallArray[14] = 14
	wallArray[15] = 12