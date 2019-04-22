extends Node2D
var damAmount = 0
var knockAmount
var hitArray = []
var team

func _ready():
	set_physics_process(false)
	return


func damage(amount,knockback,goto,teamParam):
	damAmount = amount
	knockAmount = knockback
	team = teamParam
	set_physics_process(true)
	$Sprite/anim.play("attack")

func _physics_process(delta):
	var overlappingbodies = $damageArea.get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if hitArray.find(body,0) == -1 and not body.get("team") == null and body.team != team:
			body.takedamage(damAmount,knockAmount,global_position)
			#body.knockback(VECTOR)
			hitArray.append(body)
	pass



func _on_anim_animation_finished(anim_name):
	$Sprite/anim.play("idle")
	queue_free()
	return
