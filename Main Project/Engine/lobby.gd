extends Node

func _ready():
	#var Http = load("http.gd")
	pass


func _on_hostbutton_pressed():
	#START SERVER
	pass # replace with function body


func _on_joinbutton_pressed():
	var ip = $Panel/addressbar.get_text()
	if (not ip.is_valid_ip_address()):
		_set_status("IP address is invalid",false)
		return
	
	#CONNECT
	pass # replace with function body
