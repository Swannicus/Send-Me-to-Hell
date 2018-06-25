extends "res://engine/entity.gd"
var player_id = 0
var weapon0
var weapon1
var weaponswapbuffer
var weaponSelected = 0
var swapBool = false
var pickUpBool = false
var hud
var ammo1 = 0
var ammo2 = 0
var ammo3 = 0
var ammo4 = 0
var mousepos = Vector2()
var overlaplist =[]
var controlBoolean = false
var id = null
var movedir = Vector2(0,0)
var lookdir = Vector2(0,0)
var camOffset = 4.5
var shakeDur = 0.0
var shakeOffset = 0.0
var shakeBool = false
onready var area = $pickuparea
#var weapon = load("res://scripts/weapons.gd")

func _ready():
#	set_process(true)
#	RayNode = get_node("RayCast2D")
	weapon0 = load("res://Scenes/weapons/crossbow.tscn")
	weapon1 = load("res://Scenes/weapons/sword.tscn")
	add_child(weapon0.instance())
	hud = load("res://Engine/HUD.tscn")
	.add_child(hud.instance())
	health = 20

func _physics_process(delta):
	if controlBoolean:
		controls_loop()
	movement_loop(movedir)
	spritedir_loop(lookdir)
	health_loop()
	overlap_loop()
	camLoop()
	if movedir != Vector2(0,0):
		animswitch("walk")
	else:
		animswitch("idle")

func overlap_loop():
	var overlappingbodies = area.get_overlapping_areas()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if body.is_in_group("ammo"):
			#increase ammo
			#play pick up noise
			$ammonoise.play()
			#match d :
			ammo1 += 10
			$HUD/tempammo.set_value(ammo1)
			#display increased ammo amount
			body.get_parent().queue_free()

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
	var overLappingAreas = area.get_overlapping_areas()
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
		$WeaponParent/weapon.attack()
	if swap:
		.remove_child($WeaponParent)
		.add_child(weapon1.instance())
		weaponswapbuffer = weapon1
		weapon1 = weapon0
		weapon0 = weaponswapbuffer
		swapBool = true
	pickUpBool = false
	if grab:
		for i in overLappingAreas:
			print(str(i))
			print(str(i.get_groups()))
			for g in i.get_groups():
				match g:
					"axe":
						grabWeapon(i)
						weapon0 = load("res://Scenes/weapons/"+g+".tscn")
						.remove_child($WeaponParent)
						.add_child(weapon0.instance())
					"sword":
						grabWeapon(i)
						weapon0 = load("res://Scenes/weapons/"+g+".tscn")
						.remove_child($WeaponParent)
						.add_child(weapon0.instance())
					"crossbow":
						grabWeapon(i)
						weapon0 = load("res://Scenes/weapons/"+g+".tscn")
						.remove_child($WeaponParent)
						.add_child(weapon0.instance())
	rpc_unreliable("sync",movedir,lookdir,player_id,swapBool,pickUpBool)
	$Camera2D.current = true
	$WeaponParent/weapon.lookLoop()

func grabWeapon(i):
	var lastDropped
	i.get_parent().queue_free()
	print("parent"+str(i.get_parent()))
	lastDropped = weapon0.instance()
	lastDropped.global_position = self.global_position
	get_parent().add_child(lastDropped)
	pickUpBool = true

func camLoop():
	var ranX
	var ranY
	if shakeBool == false:
		$Camera2D.position = mousepos/camOffset
		return
	while shakeDur >= 0:
		shakeDur = (shakeDur - 0.1)
		ranX = randf()*shakeOffset+1
		ranY = randf()*shakeOffset+1
		$Camera2D.position = mousepos/camOffset+Vector2(ranX,ranY)
		shakeOffset = shakeOffset*0.9
	shakeBool = false

func camShake(offset,duration):
	shakeBool = true
	shakeOffset += offset
	shakeDur += duration

remote func sync(moved,lookd,id,swapped,pickup):
	movedir = moved
	lookdir = lookd
	if swapped:
		.remove_child($WeaponParent)
		.add_child(weapon1.instance())
		weaponswapbuffer = weapon1
		weapon1 = weapon0
		weapon0 = weaponswapbuffer
#	if pickup:
#		pickup some garbage
