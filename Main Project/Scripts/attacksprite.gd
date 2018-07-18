extends Node2D
var damAmount = 0
var knockAmount = 0
var hitArray = []

func _ready():
	set_physics_process(false)
	return
	

func damage(amount,knockback,goto):
	damAmount = amount
	knockAmount = knockback
	set_physics_process(true)
	$Sprite/anim.play("attack")
	self.position = goto
	print("damagecalled")

func _physics_process(delta):
	var overlappingbodies = $damageArea.get_overlapping_bodies()
	if not overlappingbodies:
		print("nooverlap")
		return
	for body in overlappingbodies:
		if hitArray.find(body,0) == -1 and body.is_in_group("enemy"):
			print("damaged")
			body.takedamage(damAmount,knockAmount,global_position)
			#body.knockback(VECTOR)
			hitArray.append(body)
	pass



func _on_anim_animation_finished(anim_name):
	#self.queue_free()
	#Don't need to destroy, it just gets moved and reanimated every time
	$Sprite/anim.play("idle")
	queue_free()
	return
