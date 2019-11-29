#warning-ignore-all:unused_variable
extends KinematicBody2D

onready var timer = $Timer
onready var muzzle = preload("res://assests/muzzle.tscn")
onready var impact = preload("res://assests/impact.tscn")
onready var root = get_tree().get_root()

export var speed: int = 200
export var livetime: int = 1
export var damage: int = 1

enum shot_dir {LEFT, RIGHT, UP}

var _velocity = Vector2()
var first_time = true

func _ready():
	$AnimationPlayer.play("bullet")
	timer.wait_time = livetime
	timer.start()
	

func _physics_process(delta):
	if first_time:
		first_time = false
		var _muzzle = muzzle.instance()
		_muzzle.global_position = global_position
		root.add_child(_muzzle)
		
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision:
			if collision.collider.name == "alien":
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
		rotation_degrees = 90
		_velocity.y -= speed

func destroy():
	var _impact = impact.instance()
	_impact.global_position = global_position
	root.add_child(_impact)
	visible = false
	timer.wait_time = 0.3
	timer.start()

func _on_Timer_timeout():
	queue_free()
	

