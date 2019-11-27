#warning-ignore-all:unused_variable
extends KinematicBody2D

export var speed: int = 800
export var livetime: int = 1

enum shot_dir {LEFT, RIGHT, UP}

var _velocity = Vector2()

func _ready():
	yield(get_tree().create_timer(livetime), "timeout")
	queue_free()


func _physics_process(delta):
	var collision = move_and_collide(_velocity * delta)
	if collision:
	    _velocity = _velocity.slide(collision.normal)

	# using move_and_slide
	_velocity = move_and_slide(_velocity)

func set_direction(dir):
	if dir == shot_dir.LEFT:
		_velocity.x -= speed
	elif dir == shot_dir.RIGHT:
		_velocity.x += speed
	elif dir == shot_dir.UP:
		_velocity.y -= speed
