extends Node2D

var height = 30
var width = 90
var room_distance_max = 5
var room_distance_min = 2
var room_height_max = 10
var room_height_min = 3
var room_width_max = 15
var room_width_min = 3
var grid = Array()
var oddcell = Vector2()
var roomsizesum = 0
var roomorigin = Vector2(1,1)
var startpoint = Vector2()
var endpoint = Vector2()
var startroom = true
var roomnumber = 0
var targetroomnumber = 10
var slimemin = 1
var slimecurrent = 1
var slimemax = 5
var slime = load("res://Scenes/Gelatinouscube.tscn")
var gob = load("res://Scenes/Gelatinouscube.tscn")
var Walls
var Floor
var Corners
var cornerGrid = []

func _ready():
	var music = get_node("/root/Globals/audio")
	Walls = $Nav/Walls
	Floor = $Nav/Floor
	Corners = $Nav/Walls/Corners
	slime = load("res://Scenes/Gelatinouscube.tscn")
	gob = load("res://Scenes/Gelatinouscube.tscn")
	music.stream = load("res://music/Seb Song.wav")
	music.play(0)
	for i in Globals.playersdict.keys():
		spawn_player(i)
	print(str(Globals.playersdict.keys()))
	while roomnumber < targetroomnumber:
		room(roomorigin)
		roomnumber += 1
	pass
	

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

func roomWalker(xCell,yCell):
	var i = 0
	var direction = Vector2(0,0)
	var walkerTiles = [Vector2(0,0)]
	placeFloor(xCell,yCell)
	walkerTiles[0] = Vector2(xCell,yCell)
	while i < 40:
		direction = dir.rand()
		xCell += direction.x
		yCell += direction.y
		placeFloor(xCell,yCell)
		walkerTiles.append(Vector2(xCell,yCell))
		i += 1
	return walkerTiles


func room(origin):
	var gobRef
	var slimeRef
	var roomhrange = room_height_max - room_height_min
	var roomwrange =  room_width_max - room_width_min
	var roomheight = randi()%roomhrange + room_height_min
	var roomwidth = randi()%roomwrange + room_width_min
	var roomTiles = []
	var g = 0
	roomTiles = roomWalker(origin.x,origin.y)
	roomTiles += roomWalker(origin.x,origin.y)
	roomTiles += roomWalker(origin.x,origin.y)
	while g < 5:
		var randomTile =randi()%roomTiles.size()
		slimeRef = slime.instance()
		slimeRef.global_position = Walls.map_to_world(roomTiles[randomTile])
		Walls.add_child(slimeRef)
		g += 1
	endpoint = origin
	path(startpoint,endpoint)
	startpoint = endpoint
	roomorigin = origin +Vector2(randi()%20+20,randi()%40-20)


func path(SP,EP):
	oddcell = SP
	while oddcell.x < EP.x:
		placeFloor(oddcell.x,oddcell.y)
		oddcell.x += 1
	while oddcell.y < EP.y:
		placeFloor(oddcell.x,oddcell.y)
		oddcell.y += 1

func placeFloor(xCell,yCell):
	Walls.set_cell(xCell,yCell,-1)
	Corners.set_cell(xCell*2,yCell*2-1,-1)
	Corners.set_cell(xCell*2+1,yCell*2-1,-1)
	Corners.set_cell(xCell*2,yCell*2,-1)
	Corners.set_cell(xCell*2,yCell*2+1,-1)
	if randf() <=0.6:
		Floor.set_cell(xCell,yCell,19)
	else:
		Floor.set_cell(xCell,yCell,20)
	placeWall(xCell,yCell-1)
	placeWall(xCell+1,yCell-1)
	placeWall(xCell+1,yCell)
	placeWall(xCell+1,yCell+1)
	placeWall(xCell,yCell+1)
	placeWall(xCell-1,yCell+1)
	placeWall(xCell-1,yCell)
	placeWall(xCell-1,yCell-1)

func placeWall(xCell,yCell):
	var wallstate = getWallState(xCell,yCell)
	var cornerState = getCornerState(xCell,yCell)
	var errorLabel
	var corner
	if Floor.get_cell(xCell,yCell) == -1:
		Walls.set_cell(xCell,yCell,Globals.wallArray[getWallState(xCell,yCell)])
		Corners.set_cell(xCell*2,yCell*2-1,-1)
		Corners.set_cell(xCell*2+1,yCell*2-1,-1)
		Corners.set_cell(xCell*2,yCell*2,-1)
		Corners.set_cell(xCell*2+1,yCell*2,-1)
		var surround2 = getS2(xCell,yCell)
		var surround = getS1(xCell,yCell)
		if Floor.get_cell(surround2[0][0],surround2[0][1]) in [19,20,21,22] and Floor.get_cell(surround[0][0],surround[0][1]) == -1 and Floor.get_cell(surround[1][0],surround[1][1]) == -1:
			Corners.set_cell(xCell*2,yCell*2-1,13)
		if Floor.get_cell(surround2[1][0],surround2[1][1]) in [19,20,21,22] and Floor.get_cell(surround[0][0],surround[0][1]) == -1 and Floor.get_cell(surround[2][0],surround[2][1]) == -1:
			Corners.set_cell(xCell*2+1,yCell*2-1,14)
		if Floor.get_cell(surround2[2][0],surround2[2][1]) in [19,20,21,22] and Floor.get_cell(surround[1][0],surround[1][1]) == -1 and Floor.get_cell(surround[3][0],surround[3][1]) == -1:
			Corners.set_cell(xCell*2,yCell*2,10)
		if Floor.get_cell(surround2[3][0],surround2[3][1]) in [19,20,21,22] and Floor.get_cell(surround[2][0],surround[2][1]) == -1 and Floor.get_cell(surround[3][0],surround[3][1]) == -1:
			Corners.set_cell(xCell*2+1,yCell*2,11)
		

func getWallState(xCell,yCell):
	var type = 0
	var surround = getS1(xCell,yCell)
	var surround2 = getS2(xCell,yCell)
	if Floor.get_cell(surround[0][0],surround[0][1]) in [19,20,21,22]:
		type += Globals.N
	if Floor.get_cell(surround[1][0],surround[1][1]) in [19,20,21,22]:
		type += Globals.W
	if Floor.get_cell(surround[2][0],surround[2][1]) in [19,20,21,22]:
		type += Globals.E
	if Floor.get_cell(surround[3][0],surround[3][1]) in [19,20,21,22]:
		type += Globals.S
	return type

func getCornerState(xCell,yCell):
	var type = 0
	var surround2 = getS2(xCell,yCell)
	if Floor.get_cell(surround2[0][0],surround2[0][1]) in [19,20,21,22]:
		type += Globals.NW
	if Floor.get_cell(surround2[1][0],surround2[1][1]) in [19,20,21,22]:
		type += Globals.NE
	if Floor.get_cell(surround2[2][0],surround2[2][1]) in [19,20,21,22]:
		type += Globals.SW
	if Floor.get_cell(surround2[3][0],surround2[3][1]) in [19,20,21,22]:
		type += Globals.SE
	return type

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