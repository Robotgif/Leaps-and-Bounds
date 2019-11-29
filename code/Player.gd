extends KinematicBody2D

signal update_health
signal update_score


export (int) var run_speed = 400
export (int) var gravty = 1500
export (int) var jump_speed = -1000
export (int) var jump_speed_super = -1300
export (int) var score_level = 1000
export (int) var score_jump = 10
export (int) var lives = 3
export (int) var health = 100
export (float) var fire_rate = .2
export (float) var jump_delay = .3

enum DIR_SHOSTS  {LEFT, RIGHT, UP}

onready var bullet = preload("res://assests/bullet.tscn")

onready var timer_on_air = $timer_on_air
onready var sp_player = $sp_player
onready var root_node = get_tree().get_root()

var _score = 0
var _jump_speed_moment = jump_speed
var _health_moment = health
var _velocity = Vector2()
var size_viewport = null
var last_position_y = 0
var _pos_spawn = Vector2.ZERO
var can_fire = true
var dir_shots = DIR_SHOSTS.RIGHT
var _r_bullet_pos = null
var _up_bullet_pos = null
var _l_bullet_pos = null
var bullet_pos = null
var pongo_stick = false
var release_action_active = false
var _touch_floor = true
var can_show_jump = false
var _touch_bounce = false

func get_score_level():
	return score_level
	
func get_score():
	return _score
	
func get_lives():
	return lives
	
func get_health():
	return _health_moment
	
func set_score(score):
	_score = score

func set_health(health):
	_health_moment = health

func set_lives(lv):
	lives = lv

func set_spawn(pos: Vector2):
	_pos_spawn = pos
	
func take_damage(damage):
	_health_moment -= damage
	emit_signal("update_health", _health_moment)

	
func take_score(score):
	_score += score
	emit_signal("update_score", _score)
	
func spawn():
	$particle_destroy.visible = false
	position = _pos_spawn
	$sp_player.visible = true
	_health_moment = health

func touch_bounce(jump_force):
	_touch_bounce = true	
	_jump_speed_moment = jump_force
	print(_jump_speed_moment)
	
func _ready():
	size_viewport = get_viewport_rect().size
	_pos_spawn = Vector2(size_viewport.x /2, size_viewport.y/2)
	_r_bullet_pos = get_node("sp_player/positions_shots/r_pos")
	_l_bullet_pos = get_node("sp_player/positions_shots/l_pos")
	_up_bullet_pos = get_node("sp_player/positions_shots/up_pos")
	bullet_pos = _r_bullet_pos
	
func _get_input():
	_velocity.x = 0
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var up = Input.is_action_pressed("up")
	var shots = Input.is_action_pressed("shots")
	var jump = Input.is_action_pressed("jump")
	var jump_release = Input.is_action_just_released("jump")
	var down = Input.is_action_pressed("down")
	if _touch_bounce:
		_touch_bounce = false
		_velocity.y = _jump_speed_moment
		
	if jump_release and pongo_stick:
		pongo_stick = false
	if is_on_floor():
		_touch_floor = true
		timer_on_air.stop()
		
	if not is_on_floor() and $timer_on_air.is_stopped():
		timer_on_air.start()
		_touch_floor = false
	
	if is_on_floor() and not jump and not down: #exit pongo stick
		release_action_active = false
		pongo_stick = false
		_jump_speed_moment = jump_speed
	elif is_on_floor() and down:
		get_slide_collision(0).collider.set_collision_mask_bit(1, false)
	elif not is_on_floor() and jump and release_action_active:
		_jump_speed_moment = jump_speed_super
		pongo_stick = true
	elif is_on_floor() and jump:
		_touch_bounce = false
		_velocity.y = _jump_speed_moment
		#set_collision_mask_bit(4, false)
	elif not is_on_floor() and not jump:
		release_action_active = true	

	if right:
		sp_player.flip_h = false
		dir_shots = DIR_SHOSTS.RIGHT
		bullet_pos = _r_bullet_pos
		if not shots or not is_on_floor():
			_velocity.x += run_speed
	elif left:
		sp_player.flip_h = true
		dir_shots = DIR_SHOSTS.LEFT
		bullet_pos = _l_bullet_pos
		if not shots or not is_on_floor():
			_velocity.x -= run_speed
	elif up:
		sp_player.flip_h = true
		dir_shots = DIR_SHOSTS.UP
		bullet_pos = _up_bullet_pos

		
	if shots and can_fire:
		var _bullet = bullet.instance()
		_bullet.global_position = bullet_pos.global_position
		_bullet.set_direction(dir_shots)
		root_node.add_child(_bullet)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
	_animations(left, right, up, shots, can_fire,  jump, pongo_stick)


func _animations(left, right, up, shots, can_fire,  jump, pongo_stick):
	
	if is_on_floor():
		if not (left or right or up or shots or jump):  #show animation idle
			sp_player.play("idle")
		elif (left or right) and not shots:  #show animation idle, no it is very necesary
			sp_player.play("run")            #because it does not look
		
		else:
			if not shots:
				if not pongo_stick:
					_set_status_animation("idle", 0)
				else:
					_set_status_animation("pongo_stick", 2)
			elif shots:
				if not pongo_stick:
					if dir_shots == DIR_SHOSTS.UP:
						_set_status_animation("gun",1)
					else:
						_set_status_animation("gun",0)
				else:
					if dir_shots == DIR_SHOSTS.UP:
						_set_status_animation("pongo_stick",1)
					else:
						_set_status_animation("pongo_stick",0)
			can_show_jump = false
			yield(get_tree().create_timer(jump_delay), "timeout") #a liter delay for the animation realism
			can_show_jump = true
	elif not is_on_floor() and can_show_jump:
		if not shots:
			sp_player.playing = false
			if not pongo_stick:
				_set_status_animation("jump", 0)
			else:
				_set_status_animation("pongo_stick", 5)
	
		elif shots:
			if not pongo_stick:
				if dir_shots == DIR_SHOSTS.UP:
					_set_status_animation("jump",2)
				else:
					_set_status_animation("jump",1)
			else:
				if dir_shots == DIR_SHOSTS.UP:
					_set_status_animation("pongo_stick",4)
				else:
					_set_status_animation("pongo_stick",3)
	

func _physics_process(delta):
	_get_input()
	if _health_moment > 0:
		var y  = get_viewport_transform().origin.y
		if y > (last_position_y + 200):
			last_position_y = y + 200
			take_score(score_jump)
		_velocity.y += gravty * delta
		_velocity = move_and_slide(_velocity, Vector2(0, -1))



func desintegrated():
	if _health_moment > 0:
		_health_moment = 0
		lives -= 1
		$sp_player.visible = false
		$particle_destroy.emitting = true
		$particle_destroy.show()
		timer_on_air.stop()
		emit_signal("update_health", _health_moment)
		

func die():
	if _health_moment > 0:
		_health_moment = 0
		lives -= 1
		$sp_player.visible = false
		$particle_destroy.emitting = true
		$particle_destroy.show()
		timer_on_air.stop()
		emit_signal("update_health", _health_moment)

func _on_timer_on_air_timeout():
	if not _touch_floor:
		die()
	
func _set_status_animation(animation, frame):
	sp_player.playing = false
	sp_player.animation = animation
	sp_player.frame = frame