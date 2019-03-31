extends Node2D

var roomArray = []
var tileSet = {}
var random = preload("res://Engine/randomLib.gd").new()
var monsterList = [["Cube",0.7,"res://Scenes/Gelatinouscube.tscn",100],["Goblin",0,"res://Scenes/Goblin.tscn",200]]
var Walls
var Floor
var Corners
var cornerGrid = []

class room:
	var roomTiles= {}
	var origin= Vector2(0,0)
	var points= 0
	var special= 0

func _ready():
	Walls = $Nav/Walls
	Floor = $Nav/Floor
	Corners = $Nav/Walls/Corners
	generateDungeon(5)
	for i in tileSet:
		_placeTile(i)
	pass # Replace with function body.

func _placeTile(tile):
	pass

func _spawnMonsters(room,monsterlist,points):
	while points > 0:
		monsterList.sort_custom(monsterBlock,"sort")
		for monster in monsterList:
			if random.randFloat() < monster.chance and points > monster.points:
				spawn(monster,room.randomTile)
				points -= monster.points

func spawn(monster,tile):
	var gelatinousCube = load("res://Scenes/Gelatinouscube.tscn").instance()
	gelatinousCube.global_position = Floor.map_to_world(tile)
	Walls.add_child(gelatinousCube)

func generateLevel(rooms,method,distance=15):
	tileSet = {}
	var i = 0
	var origin = Vector2(0,0)
	while i < rooms:
		
		roomArray.append(i,distance*i)
		i +=1
	return

func generateDungeon(rooms):
	var i = rooms
	roomArray.clear()
	roomArray.append(Vector2(0,0))
	while i > 0:
		tileSet.union(_generateDungeonRoom(roomArray[-1]))
		roomArray.append(roomArray[-1]+Vector2(random.randRangeInt(5,10),random.randRangeInt(-5,5)))
		tileSet.union(_generateDungeonPath(roomArray[-2],roomArray[-1]))
		i -= 1
	return roomArray[-1]

func _generateDungeonRoom(origin):
	var roomTileList = {}
	var i = 0
	while i < 5:
		i+=1
		roomTileList.union(_walker(origin,25,0.25))
	return roomTileList

func _walker(origin,distance,turnChance):
	var tileList = {}
	var newTile = origin
	var i = distance
	var direction = Vector2(1,0)
	while i > 0:
		i -= 1
		tileList.add(newTile)
		if random.randFloat() < turnChance:
			direction = random.randDir()
		newTile += direction
	return tileList

func _generateDungeonPath(point1,point2):
	var pathTileList = {}
	var nextTile = point1
	var x = point2.x - point1.x
	var y = point2.y - point1.y
	while x+abs(y) > 0:
		pathTileList.add(nextTile)
		if x > 0:
			if y != 0:
				if x/(x+abs(y)) < random.randFloat():
					nextTile.x +=1
					x -=1
				else:
					nextTile.y = (abs(y)-1)*(y/abs(y)) 
					y = (abs(y)-1)*(y/abs(y)) 
			else:
				nextTile.y = (abs(y)-1)*(y/abs(y)) 
				y = (abs(y)-1)*(y/abs(y)) 
		if y != 0:
			nextTile.y = (abs(y)-1)*(y/abs(y)) 
			y = (abs(y)-1)*(y/abs(y)) 
	return pathTileList

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
