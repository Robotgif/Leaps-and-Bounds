extends KinematicBody2D

export (int) var run_speed = 500
export (int) var gravty = 1500
export (int) var jump_speed = -1000
export (int) var score_level = 10
export (int) var lives = 3
export (int) var health = 100


var _score = 0
var _jump_speed_moment = jump_speed
var _velocity = Vector2()

func set_damage(damage):
	health -= damage
	
func add_score():
	_score += score_level
	
func get_score():
	return _score

func get_health():
	return health	

func _get_input():
	_velocity.x = 0
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	
	if is_on_floor():
		_velocity.y = _jump_speed_moment
		set_collision_mask_bit(4, false)
	if right:
		_velocity.x += run_speed
	if left:
		_velocity.x -= run_speed
	


func _physics_process(delta):
	_get_input()
	_velocity.y += gravty * delta	
	_velocity = move_and_slide(_velocity, Vector2(0, -1))

