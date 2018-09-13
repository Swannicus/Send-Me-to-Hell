extends Node2D

signal attack_finished

onready var anim = $Sprite/anim

enum STATES {idle, attack}
var current_state = idle
var attackSpriteLoad
var attackspriteref
var cooldown = 0

export(float) var shakeValue = 20
export(float) var shakeDur = 5
export(float) var cooldownValue = 5
export(int) var damage = 1
export(int) var knockback = 750

func _ready():
	set_physics_process(true)
	set_process(true)
	attackSpriteLoad = load("res://Scenes/weapons/attacksprite.tscn")
	
func attack():
	#not called here
	if cooldown == 0:
		_change_state(attack)
		cooldown = cooldownValue

func _change_state(new_state):
	var positionthing =Vector2(0,0)
	if current_state != new_state:
		current_state = new_state
		match current_state:
			idle:
#				set_process(true)
				anim.play("idle")
			attack:
#				set_process(false)
				$sound.play(0)
				anim.play("attack")
				attackspriteref = attackSpriteLoad.instance()
				get_parent().get_parent().add_child(attackspriteref)
				attackspriteref.look_at(get_global_mouse_position())
				positionthing = (get_global_mouse_position()-self.global_position).normalized()*23
				attackspriteref.damage(damage,knockback,positionthing)
				attackspriteref.position = positionthing
				print(str(positionthing))
	#			$".."/".."/attacksprite/Sprite/anim.play("attack")
	#			$".."/".."/attacksprite/Sprite.position = Vector2($"..".position - self.position).normalized() * Vector2(-23,-23)
	#			$".."/".."/attacksprite.look_at(get_global_mouse_position())
	#			$".."/".."/attacksprite.damage(damage,knockback)
				#attackspriteref.damage(damage,knockback)
				get_parent().get_parent().camShake(shakeValue,shakeDur)
		

func _physics_process(delta):
	if cooldownValue > 0:
		cooldownValue -= 1

func _process(delta):
	return

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
