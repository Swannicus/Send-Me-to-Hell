extends Node
var cooldown = 1
var currentCooldown = 0
var weaponID = 0
var damage = 1
var knockback = 750
var shakeValue = 20
var shakeDur = 5


func _ready():
	animswitch("idle")
	pass

func _physics_process(delta):
	if currentCooldown > 0:
		currentCooldown -= delta

func attack():
	#not called here
	if currentCooldown <= 0:
		_change_state(attack)
		currentCooldown = cooldownValue

func _change_state(new_state):
	var positionthing =Vector2(0,0)
	if current_state != new_state:
		current_state = new_state
		match current_state:
			idle:
#				set_process(true)
				animswitch("idle")
			attack:
#				set_process(false)
				$sound.play(0)
				animswitch("attack")
				attackAction()
				get_parent().get_parent().camShake(shakeValue,shakeDur)

func attackAction():
	var attackSpriteRef = load("res://scripts/attacksprite.gd").instance()
	get_parent().get_parent().add_child(attackspriteref)
	attackSpriteRef.look_at(get_global_mouse_position())
	attackSpriteRef.damage(damage,knockback,(get_global_mouse_position()-self.global_position).normalized()*23)
	attackSpriteRef.position = (get_global_mouse_position()-self.global_position).normalized()*23

func animswitch(animation):
	if $weapon/Sprite/anim.current_animation != animation:
		$weapon/Sprite/anim.play(animation)

func lookLoop():
	$"..".look_at(get_global_mouse_position())
	if get_global_mouse_position().x-self.global_position.x < 0 :
		if self.scale != Vector2(1,-1):
			self.apply_scale(Vector2(1,-1))
	if get_global_mouse_position().x-self.global_position.x > 0 :
		if self.scale != Vector2(1,1):
			self.apply_scale(Vector2(1,-1))