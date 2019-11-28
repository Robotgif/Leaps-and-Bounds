#warning-ignore-all:unused_variable
extends KinematicBody2D

export var speed: int = 800
export var livetime: int = 1
export var damage: int = 1

enum shot_dir {LEFT, RIGHT, UP}

var _velocity = Vector2()

func _ready():
	yield(get_tree().create_timer(livetime), "timeout")
	queue_free()


func _physics_process(delta):
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision and collision.collider.name == "alien":
			collision.collider.take_damage(damage)
			destroy()
			
	# using move_and_slide
	_velocity = move_and_slide(_velocity)

func set_direction(dir):
	if dir == shot_dir.LEFT:
		_velocity.x -= speed
	elif dir == shot_dir.RIGHT:
		_velocity.x += speed
	elif dir == shot_dir.UP:
		_velocity.y -= speed

func destroy():
	queue_free()