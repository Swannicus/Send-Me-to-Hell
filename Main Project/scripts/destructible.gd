extends StaticBody2D

var random = preload("res://Engine/randomLib.gd").new()
var bountyMinimum = 0
var bountyMaximum = 0
var health = 3
var points = 10
var chance = 50
var scenePath
var damage = 3
var stun = 0
var damageCooldown = []
var dead = false
onready var sound = $sound
onready var detector = $detectionRadius
onready var anim = $Sprite/anim
var ammoDrop
var coinDrop
var team = Globals.DESTRUCTIBLES

func _ready():
	random.setSeed(randi())
	coinDrop = Globals.coin.new(get_parent(),random.randInt())
	ammoDrop = Globals.ammo.new(get_parent(),random.randInt())
	sound.stream = load("res://sound/384647__morganpurkis__sludge-footstep-3.wav")
	pass

func _process(delta):
	_anim("idle")
	pass

func _physics_process(delta):
	pass

func takedamage(damaget,knockbackt,source):
	health = health-damaget
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
		remove_from_group("destructible")
		set_collision_mask_bit(1,false)
		set_collision_layer_bit(4,true)
		add_to_group("broken")
		#sound.stream = load("DEATHSOUND")
		sound.play(0)
		set_physics_process(false)
		set_process(false)
		dead = true
		onDeath()

func onDeath():
	return