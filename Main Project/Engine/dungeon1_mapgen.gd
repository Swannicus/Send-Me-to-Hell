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
var slimeref
var gobref

func _ready():
	var basex = 100
	var basey = 100
	slimeref = load("res://Scenes/Gelatinouscube.tscn").instance()
	gobref = load("res://Scenes/Gelatinouscube.tscn").instance()
	$Walls.add_child(slimeref)
	$Walls.add_child(gobref)
	for i in Globals.playersdict.keys():
		spawn_player(i)
	print(str(Globals.playersdict.keys()))
	while basex > -15:
		while basey > -15:
			$Walls.set_cell(basex,basey,0)
			basey = basey-1
		basey = 100
		basex = basex-1
	while roomnumber < targetroomnumber:
		room()
		if roomnumber != 1: path(endpoint,startpoint)
		room()
		path(startpoint,endpoint)
	pass

func room():
	var roomhrange = room_height_max - room_height_min
	var roomwrange =  room_width_max - room_width_min
	var roomheight = randi()%roomhrange + room_height_min
	var roomwidth = randi()%roomwrange + room_width_min
	oddcell = Vector2(roomwidth+roomorigin.x,roomheight+roomorigin.y)
	while oddcell.x > roomorigin.x:
		while oddcell.y > roomorigin.y:
			$Walls.set_cell(oddcell.x,oddcell.y,-1)
			$Floor.set_cell(oddcell.x,oddcell.y,1)
			if randf() > (slimecurrent / slimemax):
				slimeref.set_position($Floor.map_to_world(oddcell)+Vector2(0,1))
				slimeref = load("res://Scenes/Gelatinouscube.tscn").instance()
				$Walls.add_child(slimeref)
				slimecurrent += 1
			if randf() > (slimecurrent / slimemax):
				gobref.set_position($Floor.map_to_world(oddcell)+Vector2(0,1))
				gobref = load("res://Scenes/goblin.tscn").instance()
				$Walls.add_child(gobref)
				slimecurrent += 1
			oddcell.y = oddcell.y-1
		oddcell.y = roomheight+roomorigin.y
		oddcell.x = oddcell.x-1
	match startroom:
		true:
			startpoint = Vector2(roomwidth+roomorigin.x,roomheight/2+roomorigin.y)
			startroom = false
		false:
			endpoint = Vector2(1+roomorigin.x,roomheight/2+roomorigin.y)
			startroom = true
	roomorigin.x += randi()%room_distance_max + room_distance_min + roomwidth
	roomorigin.y += room_distance_min + roomheight
	roomnumber += 1
	slimecurrent = 0

func path(SP,EP):
	oddcell = SP
	while oddcell.x < EP.x:
		$Walls.set_cell(oddcell.x,oddcell.y,-1)
		$Floor.set_cell(oddcell.x,oddcell.y,1)
		oddcell.x += 1
	while oddcell.y < EP.y:
		$Walls.set_cell(oddcell.x,oddcell.y,-1)
		$Floor.set_cell(oddcell.x,oddcell.y,1)
		oddcell.y += 1
	

func initializePlayers():
	for i in Globals.playersdict.keys():
		spawn_player(i)

func spawn_player(id):
	var playerScene = load("res://Scenes/knightplay_1.tscn")
	var player 		= playerScene.instance()
	print ("Spawn player")
	print (str(id))
	print (str(get_tree().get_network_unique_id()))
	
	player.set_name(str(id))
	if id == get_tree().get_network_unique_id():
		player.set_network_master(id)
		player.player_id = id
		player.controlBoolean = true
	$Walls.add_child(player)
	player.set_position(Vector2(120,120))