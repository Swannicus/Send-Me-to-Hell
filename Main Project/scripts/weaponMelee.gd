extends "res://scripts/weaponRoot.gd"
var swingState = false


func _physics_process(delta):
	._physics_process(delta)

func attack(point):
	#not called here
	if currentCooldown <= 0:
		attackAction(point)
		currentCooldown = cooldown

func attackAction(point):
	var attackSpriteRef = load("res://Scenes/weapons/attacksprite.tscn").instance()
	sound.play()
	if swingState:
		#$Sprite.flip_v = true
		$Sprite.rotation = -50
		swingState = false
	else:
		#$Sprite.flip_v = false
		$Sprite.rotation = 10
		swingState = true
	get_parent().get_parent().get_parent().add_child(attackSpriteRef)
	get_parent().get_parent().camShake(shakeValue,shakeDur)
	attackSpriteRef.damage(damage,knockback,(point-self.global_position).normalized()*23)
	attackSpriteRef.global_position = self.global_position+(point-self.global_position).normalized()*23
	attackSpriteRef.look_at(point)
	extraAttack(point)

func extraAttack(point):
	return


func _process(delta):
	._process(delta)