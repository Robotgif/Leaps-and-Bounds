extends KinematicBody2D

onready var raycast = $RayCast2D

export var health = 1
export var speed = 10

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
	yield(get_tree().create_timer(.5), "timeout")
	queue_free()