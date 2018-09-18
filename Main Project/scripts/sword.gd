extends "res://scripts/weaponMelee.gd"

var attackSpriteLoad
var attackspriteref

func _ready():
	set_physics_process(true)
	set_process(true)
	cooldown = 1
	weaponID = 3
	damage = 2
	knockback = 750
	shakeValue = 20
	shakeDur = 5
	attackSpriteLoad = load("res://Scenes/weapons/attacksprite.tscn")

func _process(delta):
	._process(delta)

func _physics_process(delta):
	if currentCooldown <= 0:
		currentCooldown -= delta
	._physics_process(delta)

func attack(point):
	#not called here
	if currentCooldown <= 0:
		attackAction(point)
		currentCooldown = cooldown

func pickUp():
	return("res://Scenes/weapons/sword.tscn")

func attackAction(point):
	var attackSpriteRef = load("res://Scenes/weapons/attacksprite.tscn").instance()
	$sound.play()
	get_parent().get_parent().get_parent().add_child(attackSpriteRef)
	get_parent().get_parent().camShake(shakeValue,shakeDur)
	attackSpriteRef.damage(damage,knockback,(point-self.global_position).normalized()*23)
	attackSpriteRef.global_position = self.global_position+(point-self.global_position).normalized()*23
	attackSpriteRef.look_at(point)
