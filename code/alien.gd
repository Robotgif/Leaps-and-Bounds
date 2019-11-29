extends KinematicBody2D

onready var raycast = $RayCast2D
onready var timer = $Timer

enum BEHAVRIOUR {FOLLOGING, STACIT, ACTIVO, BAD, VERY_BAD}

export var health = 1
export var speed = 10
export var score = 100
export var damage_touch = 25
export var damage_fire = 10
export (BEHAVRIOUR) var behaviour = BEHAVRIOUR.STACIT
export var fire_ration = 1

var gravity = 100
var is_die = false


func _ready():
	set_physics_process(false)
	

var velocity = Vector2(speed, 1)
func take_damage(damage):
	health -= damage
	if health <= 0:
		die()
	
func _physics_process(delta):
	velocity.y += gravity * delta
	if not raycast.is_colliding():
		velocity.x *= -1
	velocity = move_and_slide(velocity, Vector2.UP)

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
