extends Area2D

signal attack_finished

onready var anim = $CollisionShape2D/Sprite/anim

enum STATES {idle, attack}
var current_state = idle
var attackspriteref

export(int) var damage = 1
export(int) var knockback = 100

func _ready():
	set_physics_process(false)
	attackspriteref = load("res://Scenes/attacksprite.tscn").instance()
	
func attack():
	#not called here
	_change_state(attack)

func _change_state(new_state):
	if current_state != new_state:
		current_state = new_state
		match current_state:
			idle:
				set_physics_process(false)
				set_process(true)
				anim.play("idle")
			attack:
				set_physics_process(true)
				set_process(false)
				anim.play("attack")
				get_parent().get_parent().add_child(attackspriteref)
				$".."/".."/attacksprite/Sprite/anim.play("attack")
				$".."/".."/attacksprite/Sprite.position = Vector2($"..".position - self.position).normalized() * Vector2(-23,-23)
				$".."/".."/attacksprite.look_at(get_global_mouse_position())
		

func _physics_process(delta):
	var overlappingbodies = get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if not body.is_in_group("enemy"):
			return
		body.takedamage(damage,knockback,global_position)
		#body.knockback(VECTOR)
		

func _process(delta):
	pass

func lookLoop():
	$"..".look_at(get_global_mouse_position())
	if get_global_mouse_position().x-self.global_position.x < 0 :
		if self.scale != Vector2(1,-1):
			self.apply_scale(Vector2(1,-1))
	if get_global_mouse_position().x-self.global_position.x > 0 :
		if self.scale != Vector2(1,1):
			self.apply_scale(Vector2(1,-1))

func _on_anim_animation_finished(anim_name):
	if anim_name == "idle":
		return
	_change_state(idle)
	emit_signal("attack_finished")
