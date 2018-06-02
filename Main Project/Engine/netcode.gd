extends Node

var serverPort = 6112
var maxPeers = 4
var players ={}
var playerName


#local info
var playerInfo = {}


func _ready():
	print("Netcode start")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_diwconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	#menu = get_node("/root/MenuLayer")
	

func start_server():
	playerName = "server"
	var host = NetworkedMultiplayerENet.new()
	
	var err = host.create_server(serverPort,maxPeers)
	if (err!=OK):
		join_server()
		return
	get_tree().set_network_peer(host)
	spawn_player(1)

func join_server(ip):
	playerName = "client"
	var host = NetworkedMultiplayerENet.new()
	
	host.create_client(ip,serverPort)
	get_tree().set_network_peer(host)
	

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
	rpc("register_new_player",get_tree().get_network_unique_id(),playerName)
	register_new_player(get_tree().get_network_unique_id(),playerName)
	
func _server_disconnected():
	quit_game()
	
remote func register_new_player(id,name):
	if get_tree().is_network_server():
		rpc_id(id,"register_new_player",1,playerName)
		for peer_id in players:
			rpc_id(id, "register_new_player",peer_id,players[peer_id])
			rpc_id(peer_id, "register_player", id, name)
	players[id] = name
	spawn_player(id)
	
remote func unregister_player(id):
	get_node("/root/"+str(id)).queue_free()
	players.erase(id)
	
func quit_game():
	get_tree().set_network_peer(null)
	players.clear()
	
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
	get_parent().add_child(player)

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
	serverPort = int($Panel/portbar.get_text())
	start_server()
	pass # replace with function body


func _on_joinbutton_pressed():
	var ip = $Panel/addressbar.get_text()
	if (not ip.is_valid_ip_address()):
		_set_status("IP address is invalid",false)
		return
	serverPort = int($Panel/portbar.get_text())
	join_server(ip)
	pass # replace with function body
