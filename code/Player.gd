extends KinematicBody2D

signal update_health
signal update_score
signal update_pongo

export (int) var run_speed = 100
export (int) var gravty = 1500
export (int) var jump_speed = -400
export (int) var jump_speed_super = -600
export (int) var score_level = 1000
export (int) var score_jump = 10
export (int) var lives = 3
export (int) var health = 100
export (float) var fire_rate = .2
export (float) var jump_delay = .3

enum DIR_SHOSTS  {LEFT, RIGHT, UP}

onready var bullet = preload("res://assests/bullet.tscn")
onready var dust = preload("res://assests/juice_dust.tscn")
onready var jump_sound = $sounds/jump_sound
onready var laser_sound = $sounds/laser_sound
onready var explosion_sound = $sounds/explosion_sound
onready var pongo_sound = $sounds/pongo_sound
onready var hurt_sound = $sounds/hurt_sound
onready var timer_on_air = $timers/timer_on_air
onready var timer_can_fire = $timers/timer_can_fire
onready var timer_can_pongo = $timers/timer_can_pongo
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
var _max_pong_sctick = 0
var can_pongo = true
var snap = true
var take_hurt = false


func set_max_pongo(value):
	_max_pong_sctick = value
	
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
	_touch_bounce = true
	take_hurt = true
	_jump_speed_moment = jump_speed
	if _health_moment - damage <= 0:
		die()
	else:
		_health_moment -= damage
		emit_signal("update_health", _health_moment)

func take_score(score):
	_score += score
	emit_signal("update_score", _score)
	
func spawn():
	$particle_destroy.visible = false
	global_position = _pos_spawn
	$sp_player.visible = true
	_health_moment = health

func touch_bounce(jump_force):
	_touch_bounce = true
	_jump_speed_moment = jump_force
		
	
func _ready():
	size_viewport = get_viewport_rect().size
	_pos_spawn = Vector2(size_viewport.x /2, size_viewport.y/2)
	_r_bullet_pos = get_node("sp_player/positions_shots/r_pos")
	_l_bullet_pos = get_node("sp_player/positions_shots/l_pos")
	_up_bullet_pos = get_node("sp_player/positions_shots/up_pos")
	bullet_pos = _r_bullet_pos
	last_position_y = global_position.y
	timer_can_fire.wait_time = fire_rate
	
func _get_input():
	_velocity.x = 0
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var up = Input.is_action_pressed("up")
	var shots = Input.is_action_pressed("shots")
	var jump = Input.is_action_pressed("jump")
	#var jump_release = Input.is_action_just_released("jump")
	var down = Input.is_action_pressed("down")
	var pongo = Input.is_action_pressed("pongo")
	var sound_pongo = false
	
	if _touch_bounce:
		_touch_bounce = false
		_velocity.y = _jump_speed_moment
		
	#if jump_release and pongo_stick:
	#	pongo_stick = false
	
	if is_on_floor():
		_touch_floor = true
		timer_on_air.stop()
		snap = true
		
	if not is_on_floor() and timer_on_air.is_stopped():
		timer_on_air.start()
		_touch_floor = false
	
	if is_on_floor() and not jump and not down: #exit pongo stick
		release_action_active = false
		pongo_stick = false
		_jump_speed_moment = jump_speed
	elif is_on_floor() and down:
		snap = false
		_velocity.y = -250
		if get_slide_count() > 0:
			get_slide_collision(0).collider.set_collision_mask_bit(1, false)
	elif not is_on_floor() and jump and pongo and can_pongo: #change jump_release
		_jump_speed_moment = jump_speed_super
		pongo_stick = true
	elif is_on_floor() and jump:
		snap = false
		_touch_bounce = false
		_velocity.y = _jump_speed_moment
		if pongo_stick:
			can_pongo = false
			sound_pongo = true
			timer_can_pongo.start()
			_max_pong_sctick -= 1
			_jump_speed_moment = jump_speed
			pongo_stick = false
			if _max_pong_sctick >= 0:
				emit_signal("update_pongo", _max_pong_sctick)
			else:
				die()
			var _dust = dust.instance()
			_dust.global_position = global_position
			root_node.add_child(_dust)
		else:
			_jump_speed_moment = jump_speed
			_velocity.y = _jump_speed_moment
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
		timer_can_fire.start()
		
	
	_animations(left, right, up, shots,  can_fire,  jump, pongo_stick)
	_make_sounds(down,  shots, jump, can_fire, sound_pongo)

var one_time = true
func _make_sounds(down, shots, jump, can_fire, pongo_stick):
	if (jump or down) and is_on_floor():
		if not pongo_stick:
			jump_sound.play()
		else:
			pongo_sound.play()
	if shots and not can_fire:
		laser_sound.play()
	if take_hurt:
		hurt_sound.play()
		take_hurt = false
		
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
		var y  = global_position.y
		if y < (last_position_y - 50):
			last_position_y = y
			take_score(score_jump)
		elif y > (last_position_y + 100) and _score > 0:
			take_score(-score_jump)
			last_position_y = y
		
		_velocity.y += gravty * delta
		var _snap = Vector2.ZERO if not snap else Vector2.DOWN
		_velocity = move_and_slide_with_snap(_velocity, _snap, Vector2(0, -1))



func desintegrated():
	if _health_moment > 0:
		die()
		

func die():
	if _health_moment > 0:
		explosion_sound.play()
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

func _on_timer_can_fire_timeout():
	can_fire = true


func _on_timer_can_pongo_timeout():
	can_pongo = true
