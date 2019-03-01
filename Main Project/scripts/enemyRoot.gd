extends RigidBody2D

var health = 3
var target = Vector2(0,0)
var speed = 100
var dirTimer = 0
var damage = 3
var damageCooldown = []
var nav = null setget set_nav
var path = []
var goal = Vector2()
var pathfindTimer = 0
onready var damager = $Area2D
onready var sound = $sound

func _ready():
	sound.stream = load("res://sound/384647__morganpurkis__sludge-footstep-3.wav")
	set_nav(get_parent().get_parent())
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
	pathfindTimer += delta
	if pathfindTimer >= 1:
		for b in $detectionRadius.get_overlapping_bodies():
			if b.is_in_group("player"):
				goal = b.get_pos()
				update_path()
				break

func set_nav(new_nav):
	nav = new_nav
	update_path()

func movement_loop(delta):
	apply_impulse(Vector2(0,0),speed*path[0].normalized())

func update_path():
	path = nav.get_simple_path(get_pos(),goal,false)
	if path.size() == 0:
		return #add the teleport back into nav mesh
	

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
