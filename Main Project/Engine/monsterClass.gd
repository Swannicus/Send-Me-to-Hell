extends Node

func _ready():
	var set = {}
	var set2 = {}
	set.add(Vector2(0,0))
	set.add(Vector2(0,1))
	set2.add(Vector2(0,1))
	set2.add(Vector2(0,2))
	set.union(set2)
	print(str(set2))