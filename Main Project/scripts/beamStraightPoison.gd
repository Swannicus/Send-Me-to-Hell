extends Area2D
var damAmount = 1
var knockAmount = 1
var hitArray = []
var team
var duration =0.2
var age = 0

func damage(amount,knockback,goto,teamParam):
	damAmount = amount
	knockAmount = knockback
	team = teamParam
	set_physics_process(true)

func _physics_process(delta):
	age += delta
	if age > duration:
		queue_free()
	var overlappingbodies = get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if hitArray.find(body,0) == -1 and not body.get("team") == null and body.team != team:
			body.takedamage(damAmount,knockAmount,global_position)
			#body.knockback(VECTOR)
			hitArray.append(body)
	pass