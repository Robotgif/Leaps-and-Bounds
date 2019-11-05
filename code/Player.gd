extends KinematicBody2D

export (int) var run_speed = 500
export (int) var gravty = 1500
export (int) var jump_speed = -1000

var jump_speed_moment = jump_speed
var velocity = Vector2()

func _get_input():
	velocity.x = 0
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	
	if is_on_floor():
		velocity.y = jump_speed_moment
		set_collision_mask_bit(4, false)
	if right:
		velocity.x += run_speed
	if left:
		velocity.x -= run_speed
	

func _physics_process(delta):
	_get_input()
	velocity.y += gravty * delta	
	velocity = move_and_slide(velocity, Vector2(0, -1))