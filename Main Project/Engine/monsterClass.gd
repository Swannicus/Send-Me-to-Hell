extends Node

class monsterBlock:
	var path = "FILEPATH"
	var points = 10
	var chance = 1
	static func sort(a,b):
		if a[1] > b[1]:
			return true
		return false

class gelatinousCube extends monsterBlock:
#	path = "res://Scenes/Gelatinouscube.tscn"
#	monsterBlock.path = "res://Scenes/Gelatinouscube.tscn"
	func _init():
		path = "jellycubepath"
	var nothing = "nothing"

func _ready():
	print(gelatinousCube.path)
	pass