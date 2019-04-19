extends Node

var maxPeers = 4
var playerName
#this dropdown shit is temporary until I art up a good looking character select.  I imagine a tavern.
onready var dropdownBox


#local info
var playerInfo = {}


func _ready():
	dropdownBox = $characterSelectPanel/characterDropdown
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_diwconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	#menu = get_node("/root/MenuLayer")
	dropdownBox.add_item("Knight")
	dropdownBox.add_item("Wizard")

func start_server(serverPort):
	playerName = $characterSelectPanel/nameBar.get_text()
	$characterSelectPanel/nameBar.readonly = true
	dropdownBox.disabled = true
	$Panel/hostbutton.disabled = true
	$Panel/joinbutton.disabled = true
	var host = NetworkedMultiplayerENet.new()
	var err = host.create_server(serverPort,maxPeers)
	if (err!=OK):
		#join_server()
		print("err!=OK")
		return
	get_tree().set_network_peer(host)
	register_new_player(get_tree().get_network_unique_id(),playerName,dropdownBox.selected)
	Globals.localPlayer = 0
	#spawn_player(1)

func join_server(ip,serverPort):
	playerName = $characterSelectPanel/nameBar.get_text()
	var host = NetworkedMultiplayerENet.new()
	
	host.create_client(ip,serverPort)
	get_tree().set_network_peer(host)
	#hardcoded player number to 1, later on should rpc from host a command that tells the client wihch player number they are
	Globals.localPlayer = 1
	

func _player_connected(id):
	pass

func _player_disconnected(id):
	unregister_player(id)
	rpc("unregister_player", id)

func _connected_ok():
	rpc_id(1,"user_ready",get_tree().get_network_unique_id(),playerName)

remote func user_ready(id,playerName):
	if get_tree().is_network_server():
		rpc_id(id,"register_in_game")

remote func register_in_game():
	rpc("register_new_player",get_tree().get_network_unique_id(),$characterSelectPanel/nameBar.get_text(),dropdownBox.selected)
	register_new_player(get_tree().get_network_unique_id(),$characterSelectPanel/nameBar.get_text(),dropdownBox.selected)
	
func _server_disconnected():
	quit_game()
	
remote func register_new_player(id,name,charS):
	if get_tree().is_network_server():
		rpc_id(id,"register_new_player",1,playerName,charS)
		for peer_id in Globals.playersdict:
			rpc_id(id, "register_new_player",peer_id,Globals.playersdict[peer_id],charS)
			rpc_id(peer_id, "register_player", id, name)
	Globals.playersdict[id] = name
	Globals.charDict[id] = charS
	#spawn_player(id)
	
remote func unregister_player(id):
	get_node("/root/"+str(id)).queue_free()
	Globals.playersdict.erase(id)
	
func quit_game():
	get_tree().set_network_peer(null)
	Globals.playersdict.clear()
	
#func spawn_player(id):
#	var playerScene = load("res://Scenes/knightplay_1.tscn")
#	var player 		= playerScene.instance()
#	print ("Spawn player")
#	print (str(id))
#	print (str(get_tree().get_network_unique_id()))
#
#	player.set_name(str(id))
#	if id == get_tree().get_network_unique_id():
#		player.set_network_master(id)
#		player.player_id = id
#		player.controlBoolean = true
#	get_parent().add_child(player)

func _set_status(text,isok):
	var label = $Panel/Status
	#simple way to show status		
	if (isok):
		label.set_text(text)
		#Make it white
	else:
		label.set_text(text)
		#make it red

func _on_hostbutton_pressed():
	start_server(int($Panel/portbar.get_text()))
	pass # replace with function body


func _on_joinbutton_pressed():
	var ip = $Panel/addressbar.get_text()
	if (not ip.is_valid_ip_address()):
		_set_status("IP address is invalid",false)
		return
	join_server(ip,int($Panel/portbar.get_text()))
	pass # replace with function body

func _on_exitButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	pass # replace with function body


func _on_startButton_pressed():
	start_server(int($Panel/portbar.get_text()))
	randomize()
	var currentSeed = randi()
	seed(currentSeed)
#	seed(1)
	print("seed"+str(currentSeed))
	print("seeded seed"+str(seed(currentSeed)))
	rpc("_remote_start",currentSeed)
	get_tree().change_scene("res://Engine/INPROGRESSDUNGEON.tscn")
	pass # replace with function body

remote func _remote_start(passSeed):
	seed(passSeed)
#	seed(1)
	get_tree().change_scene("res://Engine/INPROGRESSDUNGEON.tscn")
	print("seed"+str(passSeed))
#	print("seeded seed"+str(seed()))