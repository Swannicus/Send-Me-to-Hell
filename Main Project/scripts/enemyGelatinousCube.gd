extends RigidBody2D

var health = 3
var target = Vector2(0,0)
var speed = 100
var dirTimer = 0
var damage = 3
var damageCooldown = []
onready var damager = $Area2D
onready var sound = $sound

func _ready():
	sound.stream = load("res://sound/384647__morganpurkis__sludge-footstep-3.wav")
	pass

func process(delta):
	pass

func _physics_process(delta):
	if stun > 0:
		stun -= 1
		return
#	movement_loop(delta)
	attack_loop()
	direction_loop(delta)


func direction_loop(delta):
	if dirTimer <= 0:
		var d = randi() % 5 + 1
		if d >= 1:
			target = Vector2(randf(),randf()).normalized()
		#else:
		#	target = Vector2(1,0) NEED TO STORE REFERENCES TO PLAYER
		dirTimer = 1
		add_force(Vector2(0,0),target)
	dirTimer -= delta

func attack_loop():
	var overlappingbodies = damager.get_overlapping_bodies()
	if not overlappingbodies:
		return
	for body in overlappingbodies:
		if body.is_in_group("player"):
			body.takedamage(damage)
	return
