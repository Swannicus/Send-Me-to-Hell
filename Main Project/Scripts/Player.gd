extends "res://engine/entity.gd"

var mousepos = Vector2()
#var weapon = load("res://scripts/weapons.gd")

#func _ready():
#	set_process(true)
#	RayNode = get_node("RayCast2D")

func _physics_process(delta):
	controls_loop()
	movement_loop()
	spritedir_loop()
	if movedir != Vector2(0,0):
		animswitch("walk")
	else:
		animswitch("idle")
	
func controls_loop():
	var LEFT	= Input.is_action_pressed("ui_left")
	var RIGHT	= Input.is_action_pressed("ui_right")
	var UP		= Input.is_action_pressed("ui_up")
	var DOWN	= Input.is_action_pressed("ui_down")
	var attack	= Input.is_action_just_pressed("ui_attack")
	mousepos = get_local_mouse_position()
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	if mousepos.x >= 0:
		lookdir.x = 1
	else:
		lookdir.x = -1
	if mousepos.y >=0:
		lookdir.y = 1
	else:
		lookdir.y = -1
	if abs(mousepos.x) > abs(mousepos.y):
		lookdir.y = 0
	else:
		lookdir.x = 0
	if attack:
		$sword.attack()
	

