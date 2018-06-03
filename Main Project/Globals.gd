extends Node
var randomseed
var character1 = 0
var playersdict ={}
func _ready():
	randomize()
	randomseed = randi()
	print(str(randomseed))