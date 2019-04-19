#extends "res://Engine/entity.gd"
extends KinematicBody2D
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
var speed = 200
var gold = 0
var level = 1
var sprite
var health
var healthmax = 20
onready var area = $pickuparea
#var weapon = load("res://scripts/weapons.gd")

func _ready():
#	set_process(true)
#	RayNode = get_node("RayCast2D")
	add_child(sprite)
	sprite.global_position = global_position
	sprite.position.y -= 6
	weapon0 = load("res://Scenes/weapons/crossbow.tscn")
	weapon1 = load("res://Scenes/weapons/sword.tscn")
	add_child(weapon0.instance())
	$WeaponParent/weapon/pickUpRadius.queue_free()
	hud = load("res://Engine/HUD.tscn")
	.add_child(hud.instance())
	health = 20

func setCharacter(character):
	sprite = load("res://Scenes/"+character+"Sprite.tscn").instance()

func movement_loop(movedir,speed):
	var motion = movedir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))

func _physics_process(delta):
	if controlBoolean:
		controls_loop()
	movement_loop(movedir,speed)
	HUD_loop()
	overlap_loop()
	camLoop()
	#if movedir != Vector2(0,0):
	#	animswitch("walk")
	#else:
	#	animswitch("idle")

func overlap_loop():
	var overlappingbodies = $Vacuum.get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if body.is_in_group("pickup"):
			body.apply_impulse(Vector2(0,0),(self.global_position-body.global_position))


func HUD_loop():
	#update health ui here?
	$HUD/healthBar.set_value(health)
	$HUD/healthBar/number.set_bbcode("[center]"+str(health)+"/"+str(healthmax))
	#Take these updates out when fixing weapon ammo updates
	$HUD/purple.set_value(ammo1)
	$HUD/yellow.set_value(ammo2)
	$HUD/green.set_value(ammo3)
	$HUD/blue.set_value(ammo4)
	if health <= 0:
		var deadSprite =load("res://Scenes/deadPlayer.tscn").instance()
		get_parent().add_child(deadSprite)
		deadSprite.global_position = global_position
		$HUD/gameOverScreen.show()
		set_process(false)
		set_physics_process(false)
		sprite.queue_free()
	if gold > $HUD/goldBar.max_value:
		gold = gold-$HUD/goldBar.max_value
		level += 1
		$levelUp/Sprite/anim.play("play")
		$HUD/goldBar/number.bbcode_text = "[center]"+str(level)+"[/center]"
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
		animswitch("idleright")
	else:
		lookdir.x = -1
		animswitch("idleright")
	if attack:
		$WeaponParent/weapon.attack(get_global_mouse_position())
		rpc("syncAttack",get_global_mouse_position())
	if swap:
		.remove_child($WeaponParent)
		.add_child(weapon1.instance())
		$WeaponParent/weapon/pickUpRadius.queue_free()
		weaponswapbuffer = weapon1
		weapon1 = weapon0
		weapon0 = weaponswapbuffer
		rpc("syncSwap")
		swapBool = true
	pickUpBool = false
	if grab:
		for i in overLappingAreas:
			if i.get_parent().has_method("pickUp"):
				grabWeapon(i,i.get_parent().pickUp())
				break
	rpc_unreliable("syncP",movedir,lookdir,player_id,swapBool,pickUpBool,get_global_mouse_position(),global_position,health)
	$Camera2D.current = true
	$WeaponParent/weapon.lookLoop()

func animswitch(animation):
	var newanim = str(animation)
	if $Sprite/anim.current_animation != newanim:
		$Sprite/anim.play(newanim)
	rpc("ranimSwitch",animation)

remote func ranimSwitch(animation):
	var newanim = str(animation)
	if $Sprite/anim.current_animation != newanim:
		$Sprite/anim.play(newanim)

func grabWeapon(i,g):
	var lastDropped
	i.get_parent().queue_free()
	lastDropped = weapon0.instance()
	lastDropped.global_position = self.global_position
	get_parent().add_child(lastDropped)
	pickUpBool = true
	weapon0 = load(g)
	.remove_child($WeaponParent)
	.add_child(weapon0.instance())
	$WeaponParent/weapon/pickUpRadius.queue_free()

func camLoop():
	var ranX
	var ranY
	if get_global_mouse_position().x-self.global_position.x < 0 :
		animswitch("idleleft")
	else:
		animswitch("idleright")
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

remote func syncP(moved,lookd,id,swapped,pickup,point,gPos,nHealth):
	movedir = moved
	lookdir = lookd
	var mismatch = global_position-gPos
	$WeaponParent/weapon.lookLoop(point)
	if mismatch.length() > 10:
		global_position = gPos
	health = nHealth
#	if pickup:
#		pickup some garbage

remote func syncSwap():
	.remove_child($WeaponParent)
	.add_child(weapon1.instance())
	$WeaponParent/weapon/pickUpRadius.queue_free()
	weaponswapbuffer = weapon1
	weapon1 = weapon0
	weapon0 = weaponswapbuffer

remote func syncAttack(point):
	$WeaponParent/weapon.attack(point)

func _on_pickuparea_area_entered(area):
	var overlaps = $pickuparea.get_overlapping_areas()
	for a in overlaps:
		if area.is_in_group("chest"):
			area.get_parent().open()


func _on_pickuparea_body_entered(body):
	var overlaps = $pickuparea.get_overlapping_bodies()
	for a in overlaps:
		if body.is_in_group("ammo"):
			#increase ammo
			#play pick up noise
			$ammonoise.play()
			match body.reagent:
				1: ammo1 += 8
				2: ammo2 += 8
				3: ammo3 += 8
				4: ammo4 += 8
			$HUD/purple.set_value(ammo1)
			$HUD/yellow.set_value(ammo2)
			$HUD/green.set_value(ammo3)
			$HUD/blue.set_value(ammo4)
			body.queue_free()
		if body.is_in_group("gold"):
			$coinnoise.play()
			gold += 1
			$HUD/goldBar.set_value(gold)
			body.queue_free()
	pass # replace with function body