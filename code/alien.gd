extends KinematicBody2D

onready var raycast = $RayCast2D
onready var timer = $timers/timer_gone
onready var timer_fire = $timers/timer_fire
onready var root_node = get_tree().get_root()


enum BEHAVRIOUR {STATIC, ACTIVO, BAD, VERY_BAD}

export (PackedScene) var bullet_enemy
export var health = 1
export var speed = 20
export var score = 100
export var damage_touch = 25
export var damage_fire = 10
export (BEHAVRIOUR) var behaviour = BEHAVRIOUR.STATIC
export var fire_ration = 2

var gravity = 100
var is_die = false
var can_fire = false

func _ready():
	set_physics_process(false)
	
	if behaviour != BEHAVRIOUR.ACTIVO:
		if behaviour != BEHAVRIOUR.BAD:
			speed *= 2
			health *= 2
			score *= 2 
		elif behaviour != BEHAVRIOUR.BAD:
			speed *= 3
			health *= 3
			score *= 3 
		timer_fire.wait_time = randf()*10
		timer_fire.start()
		
	    

var velocity = Vector2(speed, 1)


func take_damage(damage):
	health -= damage
	if health <= 0:
		die()
		
func fire():
	can_fire = false
	if bullet_enemy != null:
		var _bullet = bullet_enemy.instance()
		_bullet.global_position = global_position
		root_node.add_child(_bullet)
		timer_fire.wait_time = fire_ration
		timer_fire.start()
		
func _physics_process(delta):
	if behaviour == BEHAVRIOUR.ACTIVO:
		velocity.y += gravity * delta
		if not raycast.is_colliding():
			velocity.x *= -1
		velocity = move_and_slide(velocity, Vector2.UP)
		
	if can_fire:
		fire()
	

func die():
	if not is_die:
		is_die = true
		$AnimatedSprite.visible = false
		$destroy.emitting = true
		global.player.take_score(score)
		timer.start()
	
func _on_Timer_timeout():
	queue_free()


func _on_Area2D_body_entered(body):
	if (body.name == "Player"):
		body.take_damage(damage_touch)


func _on_timer_fire_timeout():
	can_fire = true

