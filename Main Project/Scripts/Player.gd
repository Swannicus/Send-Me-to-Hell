extends "res://engine/entity.gd"
var weaponinstance0
var weaponinstance1
var HUDinstance
var mousepos = Vector2()
var overlaplist =[]
onready var area = $pickuparea
#var weapon = load("res://scripts/weapons.gd")

func _ready():
#	set_process(true)
#	RayNode = get_node("RayCast2D")
	weaponinstance0 = load("res://Scenes/sword.tscn").instance()
	weaponinstance1 = load("res://Scenes/Axe.tscn").instance()
	HUDinstance = load("res://Engine/HUD.tscn").instance()
	.add_child(HUDinstance)
	health = 20

func _physics_process(delta):
	controls_loop()
	movement_loop()
	spritedir_loop()
	health_loop()
	overlap_loop()
	if movedir != Vector2(0,0):
		animswitch("walk")
	else:
		animswitch("idle")

func overlap_loop():
	var overlappingbodies = area.get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if body.is_in_group("ammo"):
			#increase ammo
			#play pick up noise
			#display increased ammo amount
			body.free

func health_loop():
	#update health ui here?
	$HUD/Temphealthbar.set_value(health)
	$HUD/Temphealthbar/number.set_bbcode("[center]"+str(health)+"/20")
	if health <= 0:
		_Death()
	return

func takedamage(damage):
	health = health-damage

func controls_loop():
	var LEFT	= Input.is_action_pressed("ui_left")
	var RIGHT	= Input.is_action_pressed("ui_right")
	var UP		= Input.is_action_pressed("ui_up")
	var DOWN	= Input.is_action_pressed("ui_down")
	var attack	= Input.is_action_just_pressed("ui_attack")
	var swap	= Input.is_action_just_pressed("ui_swap")
	var grab	= Input.is_action_just_pressed("ui_grab")
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
		$WeaponParent2/weapon.attack()
	if swap:
		if $WeaponParent.is_in_group("Sword"):
			.remove_child($WeaponParent)
			.add_child(weaponinstance1)
		else:
			.remove_child($WeaponParent)
			.add_child(weaponinstance0)
	#if grab:
	#	if overlaplist.bsearch_custom(
	#		t
	
	

