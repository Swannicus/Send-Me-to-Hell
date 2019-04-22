extends RigidBody2D

var random = preload("res://Engine/randomLib.gd").new()
var bountyMinimum = 0
var bountyMaximum = 4
var health = 3
var points = 10
var chance = 50
var scenePath
var target = Vector2(0,0)
var speed = 3
var dirTimerMax = 1
var dirTimer = 0
var pathfindTimerMax = 3
var pathfindTimer = 0
var focusFloat = 0.5
var damage = 3
var stun = 0
var damageCooldown = []
var nav = null setget set_nav
var path = []
var goal = Vector2()
var dead = false
onready var sound = $sound
onready var detector = $detectionRadius
onready var anim = $Sprite/anim
var ammoDrop
var coinDrop
var team = Globals.MONSTERS

func _ready():
	random.setSeed(randi())
	coinDrop = Globals.coin.new(get_parent(),random.randInt())
	ammoDrop = Globals.ammo.new(get_parent(),random.randInt())
	sound.stream = load("res://sound/384647__morganpurkis__sludge-footstep-3.wav")
	set_nav(get_parent().get_parent())
	pass

func _process(delta):
	if stun > 0:
		stun -= delta
		return
	movement_loop(delta)
	attack_loop()
	pathfind_loop(delta)
	direction_loop(delta)
	pass

func _physics_process(delta):
	pass


func set_nav(new_nav):
	nav = new_nav
	update_path()

func pathfind_loop(delta):
	pathfindTimer -= delta
	if pathfindTimer <= 0:
		pathfindTimer = pathfindTimerMax
		for b in detector.get_overlapping_bodies():
			if b.is_in_group("player"):
				goal = b.global_position
				update_path()
				break

func movement_loop(delta):
	apply_central_impulse(speed*target)

func update_path():
	path = nav.get_simple_path(Vector2(0,0),global_position-goal,true)
	if path.size() == 0:
		return #add the teleport back into nav mesh

func direction_loop(delta):
	if dirTimer <= 0:
		var d = random.randFloat()
		target = Vector2(random.randRangeFloat(-1,1),random.randRangeFloat(-1,1)).normalized()
		if d >= focusFloat:
			if path[0]:
				target = path[0].normalized()
		dirTimer = dirTimerMax
	dirTimer -= delta


func attack_loop():
	return

func takedamage(damaget,knockbackt,source):
	health = health-damaget
	stun = 10
	var directionkb = global_position - source
	apply_impulse(Vector2(0,0),knockbackt*directionkb.normalized())
	if health <= 0:
		_Death()
		return
	_anim("damaged",true)

func _anim(animation,interrupt=false):
	var newanim = str(animation)
	if interrupt:
		$Sprite/anim.play(newanim)
	else:
		if $Sprite/anim.current_animation != newanim:
			$Sprite/anim.queue(newanim)

func _Death():
	if dead == false:
		_anim("death",true)
		if is_in_group("enemy"):
			set_collision_mask_bit(1,false)
			set_collision_layer_bit(1,false)
			set_collision_layer_bit(4,true)
			team = null
			ammoDrop.drop(global_position)
			for i in random.randRangeInt(bountyMinimum,bountyMaximum):
				coinDrop.drop(global_position)
			#sound.stream = load("DEATHSOUND")
			sound.play(0)
			set_physics_process(false)
			set_process(false)
		dead = true