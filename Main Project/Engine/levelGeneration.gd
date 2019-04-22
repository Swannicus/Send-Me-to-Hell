extends Node2D

var roomArray = []
var tileArray = []
var random = preload("res://Engine/randomLib.gd").new()
var monsterList = []
var monsterInLevelArray = []
var Walls
var Floor
var walkableWalls
var Corners
var cornerGrid = []
enum {NORMAL_ROOM,HELLPEARL_ROOM,TREASURE_ROOM}

class room:
	var tiles= []
	var origin= Vector2(0,0)
	var points= 0
	var special= 0
	var random = preload("res://Engine/randomLib.gd").new()
	var monsterList = []
	var Walls
	var Floor
	
	func randomTile():
		var selectedTile = origin
		if tiles.size() != 0:
			selectedTile = tiles[random.randRangeInt(0,tiles.size()-1)]
		return selectedTile
	
	func spawnMonsters():
		var totalChance = 0
		var roll = 0
		for monster in monsterList:
			totalChance += monster.chance
		while points > 0:
			roll = random.randRangeInt(0,totalChance)
			for monster in monsterList:
				if roll > monster.chance:
					roll -= monster.chance
				else:
					spawn(monster,randomTile())
					points -= monster.points
	
	func spawn(type,tile):
		var monster = load(type.scenePath).instance()
		monster.global_position = Floor.map_to_world(tile)+Vector2(16,16)
		Walls.add_child(monster)
		Globals.monstersInLevelArray.append(monster)
	
	func _init(origin_param,points_param,monsterList_param,wallRef,floorRef,special_param = 0):
		origin = origin_param
		points = points_param
		special = special_param
		monsterList = monsterList_param
		Floor = floorRef
		Walls = wallRef

func _ready():
	random.randomizeSeed()
	Walls = $Nav/Walls
	Floor = $Nav/Floor
	Corners = $Nav/Walls/Corners
	walkableWalls = $Nav/walkableWalls
	dungeonMonsters()
	generateDungeon(5)
	pass # Replace with function body.

func _placeTile(tile):
	var xCell = tile.x
	var yCell = tile.y
	Walls.set_cell(xCell,yCell,-1)
	walkableWalls.set_cell(xCell,yCell,-1)
	if Floor.get_cell(xCell,yCell+1) != -1:
		walkableWalls.set_cell(xCell,yCell+1,-1)
	Corners.set_cell(xCell*2,yCell*2-1,-1)
	Corners.set_cell(xCell*2+1,yCell*2-1,-1)
	Corners.set_cell(xCell*2,yCell*2,-1)
	Corners.set_cell(xCell*2,yCell*2+1,-1)
	if randf() <=0.6:
		Floor.set_cell(xCell,yCell,26)
	else:
		match random.randRangeInt(0,3):
			0:
				Floor.set_cell(xCell,yCell,27)
			1:
				Floor.set_cell(xCell,yCell,28)
			2:
				Floor.set_cell(xCell,yCell,29)
			3:
				Floor.set_cell(xCell,yCell,29)
	placeWall(xCell,yCell-1)
	placeWall(xCell+1,yCell-1)
	placeWall(xCell+1,yCell)
	placeWall(xCell+1,yCell+1)
	placeWall(xCell,yCell+1)
	placeWall(xCell-1,yCell+1)
	placeWall(xCell-1,yCell)
	placeWall(xCell-1,yCell-1)
	pass

func placeWall(xCell,yCell):
	var wallstate = getWallState(xCell,yCell)
	var cornerState = getCornerState(xCell,yCell)
	var errorLabel
	var corner
	if Floor.get_cell(xCell,yCell) == -1:
		Walls.set_cell(xCell,yCell,Globals.wallArray[getWallState(xCell,yCell)])
		if getWallState(xCell,yCell) in [8,9,10,12,11,15,15,14,13]:
			walkableWalls.set_cell(xCell,yCell+1,random.randRangeInt(21,25))
		Corners.set_cell(xCell*2,yCell*2-1,-1)
		Corners.set_cell(xCell*2+1,yCell*2-1,-1)
		Corners.set_cell(xCell*2,yCell*2,-1)
		Corners.set_cell(xCell*2+1,yCell*2,-1)
		var surround2 = getS2(xCell,yCell)
		var surround = getS1(xCell,yCell)
		if Floor.get_cell(surround2[0][0],surround2[0][1]) in [26,27,28,29] and Floor.get_cell(surround[0][0],surround[0][1]) == -1 and Floor.get_cell(surround[1][0],surround[1][1]) == -1:
			Corners.set_cell(xCell*2,yCell*2-1,18)
		if Floor.get_cell(surround2[1][0],surround2[1][1]) in [26,27,28,29] and Floor.get_cell(surround[0][0],surround[0][1]) == -1 and Floor.get_cell(surround[2][0],surround[2][1]) == -1:
			Corners.set_cell(xCell*2+1,yCell*2-1,17)
		if Floor.get_cell(surround2[2][0],surround2[2][1]) in [26,27,28,29] and Floor.get_cell(surround[1][0],surround[1][1]) == -1 and Floor.get_cell(surround[3][0],surround[3][1]) == -1:
			Corners.set_cell(xCell*2,yCell*2,19)
		if Floor.get_cell(surround2[3][0],surround2[3][1]) in [26,27,28,29] and Floor.get_cell(surround[2][0],surround[2][1]) == -1 and Floor.get_cell(surround[3][0],surround[3][1]) == -1:
			Corners.set_cell(xCell*2+1,yCell*2,16)

func getS1(xCell,yCell):
	var surround
	surround = [		[0,-1],
				[-1,0],			[1,0],
						[0,1]		]
	for i in range(0,surround.size()):
		surround[i][0]+=xCell
		surround[i][1]+=yCell
	return surround

func getS2(xCell,yCell):
	var surround2
	surround2 = [[-1,-1]		,	[1,-1],
				[-1,1]		,	[1,1]]
	for i in range(0,surround2.size()):
		surround2[i][0]+=xCell
		surround2[i][1]+=yCell
	return surround2

func getWallState(xCell,yCell):
	var type = 0
	var surround = getS1(xCell,yCell)
	var surround2 = getS2(xCell,yCell)
	if Floor.get_cell(surround[0][0],surround[0][1]) in [26,27,28,29]:
		type += Globals.N
	if Floor.get_cell(surround[1][0],surround[1][1]) in [26,27,28,29]:
		type += Globals.W
	if Floor.get_cell(surround[2][0],surround[2][1]) in [26,27,28,29]:
		type += Globals.E
	if Floor.get_cell(surround[3][0],surround[3][1]) in [26,27,28,29]:
		type += Globals.S
	return type

func getCornerState(xCell,yCell):
	var type = 0
	var surround2 = getS2(xCell,yCell)
	if Floor.get_cell(surround2[0][0],surround2[0][1]) in [26,27,28,29]:
		type += Globals.NW
	if Floor.get_cell(surround2[1][0],surround2[1][1]) in [26,27,28,29]:
		type += Globals.NE
	if Floor.get_cell(surround2[2][0],surround2[2][1]) in [26,27,28,29]:
		type += Globals.SW
	if Floor.get_cell(surround2[3][0],surround2[3][1]) in [26,27,28,29]:
		type += Globals.SE
	return type

func generateLevel(rooms,method,distance=15):
	tileArray = []
	var i = 0
	var origin = Vector2(0,0)
	while i < rooms:
		
		roomArray.append(i,distance*i)
		i +=1
	return

func dungeonMonsters():
	monsterList.append(load("res://scripts/enemyOrclops.gd").new())
	monsterList.append(load("res://scripts/enemyGelatinousCube.gd").new())

func generateDungeon(rooms):
	roomArray.clear()
	roomArray.append(Vector2(0,0))
	var tempTileArray = _generateDungeonRoom(roomArray[-1])
	for tile in tempTileArray:
		if tileArray.has(tile) == false:
			tileArray.append(tile)
	for i in rooms-1:
		roomArray.append(roomArray[-1]+Vector2(random.randRangeInt(7,15),random.randRangeInt(-10,10)))
		tempTileArray = _generateDungeonRoom(roomArray[-1])
		for tile in tempTileArray:
			if tileArray.has(tile) == false:
				tileArray.append(tile)
		tempTileArray = _generateDungeonPath(roomArray[-2],roomArray[-1])
		for tile in tempTileArray:
			if tileArray.has(tile) == false:
				tileArray.append(tile)
	for i in tileArray:
		_placeTile(i)
	_generateDungeonRoom(roomArray[-1],HELLPEARL_ROOM)
	initializePlayers()
	return roomArray[-1]

func _generateDungeonRoom(origin,method=NORMAL_ROOM):
	var thisRoom
	var tempTileArray = []
	match method:
		NORMAL_ROOM:
			thisRoom = room.new(origin,100,monsterList,Walls,Floor)
			for i in 7:
				tempTileArray = _walker(origin,15,0.9)
				for tile in tempTileArray:
					if thisRoom.tiles.has(tile) == false:
						thisRoom.tiles.append(tile)
			thisRoom.spawnMonsters()
		HELLPEARL_ROOM:
			thisRoom = room.new(origin,0,monsterList,Walls,Floor)
			for i in 9:
				tempTileArray = _walker(origin,20,0.8)
				for tile in tempTileArray:
					if thisRoom.tiles.has(tile) == false:
						thisRoom.tiles.append(tile)
			var hellpearl = load("res://Scenes/hellpearl.tscn").instance()
			hellpearl.global_position = Floor.map_to_world(roomArray[-1])+Vector2(16,16)
			Walls.add_child(hellpearl)
	return thisRoom.tiles

func _walker(origin,distance,turnChance):
	var walkerTileArray = []
	var newTile = origin
	var i = distance
	var direction = Vector2(1,0)
	while i > 0:
		i -= 1
		walkerTileArray.append(newTile)
		if random.randFloat() < turnChance:
			direction = random.randDir()
		newTile += direction
	return walkerTileArray

func _generateDungeonPath(point1,point2):
	var pathTileList = []
	var nextTile = point1
	var x = point2.x - point1.x
	var y = point2.y - point1.y
	while x > 0:
		pathTileList.append(nextTile)
		if y != 0:
			if x/(x+abs(y)) > random.randFloat():
				nextTile.x +=1
				x -=1
			else:
				nextTile.y += y/abs(y)
				y -= y/abs(y)
		else:
			nextTile.x += 1
			x -= 1
	while y != 0:
		pathTileList.append(nextTile)
		nextTile.y += y/abs(y)
		y -= y/abs(y)
	return pathTileList

func initializePlayers():
	for i in Globals.playersdict.keys():
		spawn_player(i)

func spawn_player(id):
	var player = load("res://Scenes/playerRoot.tscn").instance()
	print ("Spawn player "+str(id)+" "+str(get_tree().get_network_unique_id()))
	player.setCharacter("knight")
	player.set_name(str(id))
	if id == get_tree().get_network_unique_id():
		player.set_network_master(id)
		player.player_id = id
		player.controlBoolean = true
	Walls.add_child(player)
	player.set_position(Vector2(16,16))