extends Node2D
var cooldown = 0.9
var currentCooldown = 0
var cooldown2 = 1.5
var weaponID = 0
var damage = 1
var knockback = 500
var shakeValue = 20
var shakeDur = 5
var ammoType = 0
var ammoCost = 0
var AIRange = 55
onready var sound = $sound
onready var sprite = $Sprite
var attackSpriteLoad = load("res://Scenes/weapons/attacksprite.tscn")
var random = preload("res://Engine/randomLib.gd").new()
var attackSpriteRef
var circleArray = []
var t
var attackCharging = false
var charge = 0

	
func _ready():
	pass

func _physics_process(delta):
	return

func _process(delta):
	if currentCooldown > 0:
		currentCooldown -= delta
	if attackCharging:
		charge += delta
	return

func attackdown(point):
	#not called here
	if currentCooldown <= 0:
		attackAction(point)
		currentCooldown = cooldown

func attackup(point):
	return

func attack2up(point):
		#not called here
	attackCharging = false
	print("cooldown"+str(currentCooldown)+"+"+"charge"+str(charge))
	if currentCooldown <= 0 and charge >= 0.5:
		attackAction2(point)
		currentCooldown = cooldown2
	charge = 0
	return

func attack2down(point):
	attackCharging = true
	print("Charging")
	return

func attackAction(point):
	attackSpriteRef = attackSpriteLoad.instance()
	sound.play()
	get_parent().get_parent().get_parent().add_child(attackSpriteRef)
	get_parent().get_parent().camShake(shakeValue,shakeDur)
	attackSpriteRef.damage(damage,knockback,(point-self.global_position).normalized()*23,get_parent().team)
	attackSpriteRef.global_position = self.global_position+(point-self.global_position).normalized()*23
	attackSpriteRef.look_at(point)
	
func attackAction2(point):
	return

func lookLoop(mousePos=get_global_mouse_position()):
	$"..".look_at(mousePos)
	if mousePos.x-self.global_position.x < 0 :
		if self.scale != Vector2(1,-1):
			self.apply_scale(Vector2(1,-1))
	if mousePos.x-self.global_position.x > 0 :
		if self.scale != Vector2(1,1):
			self.apply_scale(Vector2(1,-1))
#	rpc_unreliable(get_tree().get_network_unique_id(),mousePos)

remote func rlookLoop(id,point):
	$"..".look_at(point)
	if point.x-self.global_position.x < 0 :
		if self.scale != Vector2(1,-1):
			self.apply_scale(Vector2(1,-1))
	if point.x-self.global_position.x > 0 :
		if self.scale != Vector2(1,1):
			self.apply_scale(Vector2(1,-1))

func monsterLookLoop(direction):
	$"..".look_at(direction)
	if direction.x-self.global_position.x < 0 :
		if self.scale != Vector2(1,-1):
			self.apply_scale(Vector2(1,-1))
	if direction.x-self.global_position.x > 0 :
		if self.scale != Vector2(1,1):
			self.apply_scale(Vector2(1,-1))