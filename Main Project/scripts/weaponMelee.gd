extends "res://scripts/weaponRoot.gd"
var swingState = false

func attackAction(point):
	attackSpriteRef = attackSpriteLoad.instance()
	sound.play()
	if swingState:
		#$Sprite.flip_v = true
		sprite.rotation = -50
		swingState = false
	else:
		#$Sprite.flip_v = false
		sprite.rotation = 10
		swingState = true
	get_parent().get_parent().get_parent().add_child(attackSpriteRef)
#	get_parent().get_parent().camShake(shakeValue,shakeDur)
	attackSpriteRef.damage(damage,knockback,(point-global_position).normalized()*23,get_parent().get_parent().team)
	attackSpriteRef.global_position = global_position+(point-global_position).normalized()*23
	attackSpriteRef.look_at(point)
	extraAttack(point)

func extraAttack(point):
	return