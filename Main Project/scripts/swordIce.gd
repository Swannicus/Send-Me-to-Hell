extends "res://scripts/weaponMelee.gd"

signal attack_finished

const projScene = preload("res://Scenes/weapons/iceCrystal.tscn")
onready var anim = $CollisionShape2D/Sprite/anim

enum STATES {idle, attack}
var current_state = idle
var attackSpriteLoad
var attackspriteref

func _ready():
	set_physics_process(true)
	set_process(true)
	cooldown = 1
	weaponID = 3
	damage = 2
	knockback = 750
	shakeValue = 20
	shakeDur = 5
	attackSpriteLoad = load("res://Scenes/weapons/attacksprite.tscn")

func _process(delta):
	._process(delta)

func _physics_process(delta):
	._physics_process(delta)

func attack():
	#not called here
	if currentCooldown <= 0:
		_change_state("attack")
		currentCooldown = cooldown

func _change_state(new_state):
	var current_state
	var positionthing =Vector2(0,0)
	if current_state != new_state:
		current_state = new_state
		match current_state:
			"idle":
				animswitch("idle")
			"attack":
				var proj = projScene.instance()
				var angle = get_global_mouse_position() - $".."/muzzle.global_position
				$sound.play(0)
				animswitch("attack")
				attackAction()
				get_parent().get_parent().camShake(shakeValue,shakeDur)
				proj.setup(angle.normalized())
				proj.global_position = $".."/muzzle.global_position
				get_parent().get_parent().get_parent().add_child(proj)

func attackAction():
	var attackSpriteRef = load("res://Scenes/weapons/attacksprite.tscn").instance()
	get_parent().get_parent().add_child(attackSpriteRef)
	attackSpriteRef.look_at(get_global_mouse_position())
	attackSpriteRef.damage(damage,knockback,(get_global_mouse_position()-self.global_position).normalized()*23)
	attackSpriteRef.position = (get_global_mouse_position()-self.global_position).normalized()*23

func _on_anim_animation_finished(anim_name):
	if anim_name == "idle":
		return
	_change_state(idle)
	emit_signal("attack_finished")
