extends Node
var cooldown = 1
var currentCooldown = 0
var weaponID = 0
var damage = 1
var knockback = 750
var shakeValue = 20
var shakeDur = 5
var ammoType = 0
var ammoCost = 0
onready var sound = $sound

func _ready():
	pass

func _physics_process(delta):
	if currentCooldown > 0:
		currentCooldown -= delta

func _process(delta):
	return

func attack(point):
	#not called here
	if currentCooldown <= 0:
		attackAction(point)
		currentCooldown = cooldown

func attackAction(point):
	var attackSpriteRef = load("res://Scenes/weapons/attacksprite.tscn").instance()
	sound.play()
	get_parent().get_parent().get_parent().add_child(attackSpriteRef)
	get_parent().get_parent().camShake(shakeValue,shakeDur)
	attackSpriteRef.damage(damage,knockback,(point-self.global_position).normalized()*23)
	attackSpriteRef.global_position = self.global_position+(point-self.global_position).normalized()*23
	attackSpriteRef.look_at(point)

func lookLoop(mousePos=get_global_mouse_position()):
#	var mousePos = get_global_mouse_position()
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