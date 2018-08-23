extends Node2D
var damAmount = 0
var knockAmount
var hitArray = []

func _ready():
	set_physics_process(false)
	return


func damage(amount,knockback,goto):
	damAmount = amount
	knockAmount = knockback
	set_physics_process(true)
	$Sprite/anim.play("attack")

func _physics_process(delta):
	var overlappingbodies = $damageArea.get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if hitArray.find(body,0) == -1 and body.is_in_group("enemy"):
			body.takedamage(damAmount,knockAmount,global_position)
			#body.knockback(VECTOR)
			hitArray.append(body)
	pass



func _on_anim_animation_finished(anim_name):
	$Sprite/anim.play("idle")
	queue_free()
	return
