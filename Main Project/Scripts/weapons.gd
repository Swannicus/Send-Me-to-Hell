extends Area2D

signal attack_finished

onready var anim = $Sprite/anim

enum STATES {idle, attack}
var current_state = idle

export(int) var damage = 1

func _ready():
	set_physics_process(false)
	
func attack():
	#not called here
	_change_state(attack)

func _change_state(new_state):
	current_state = new_state
	match current_state:
		idle:
			set_physics_process(false)
			set_process(true)
		attack:
			set_physics_process(true)
			set_process(false)
			anim.play("attack")
	print(current_state)
		

func _physics_process(delta):
	var overlappingbodies = get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if not body.is_in_group("enemy"):
			return
		body.takedamage(damage)
		

func _process(delta):
	look_at(get_global_mouse_position())

func _on_anim_animation_finished(anim_name):
	if name == "attack":
		_change_state(idle)
		emit_signal("attack_finished")
