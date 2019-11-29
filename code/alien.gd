extends KinematicBody2D

onready var raycast = $RayCast2D
onready var timer = $Timer

export var health = 1
export var speed = 10
export var score = 100

var gravity = 100

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
	$AnimatedSprite.visible = false
	$destroy.emitting = true
	global.player.take_score(score)
	timer.start()
	
func _on_Timer_timeout():
	queue_free()
