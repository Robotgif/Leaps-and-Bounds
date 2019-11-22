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

enum DIR_SHOSTS  {LEFT, RIGHT, UP}

onready var bullet = preload("res://assests/shots.tscn")
onready var timer_on_air = $timer_on_air

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
	$Particles2D.visible = false
	position = _pos_spawn
	$sp_player.visible = true
	_health_moment = health
	
	
func _ready():
	size_viewport = get_viewport_rect().size
	_pos_spawn = Vector2(size_viewport.x /2, size_viewport.y/2)
	_r_bullet_pos = get_node("sp_player/positions_shots/r_pos")
	_l_bullet_pos = get_node("sp_player/positions_shots/l_pos")
	_up_bullet_pos = get_node("sp_player/positions_shots/up_pos")
	bullet_pos = _r_bullet_pos
	
func _get_input():
	_set_positon_about_visivilty_status()
	_velocity.x = 0
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var up = Input.is_action_pressed("up")
	var shots = Input.is_action_pressed("shots")
	var jump = Input.is_action_pressed("jump")
	
	if is_on_floor():
		_touch_floor = true
		timer_on_air.stop()
	
	if not is_on_floor() and $timer_on_air.is_stopped():
		timer_on_air.start()
		_touch_floor = false
		
	if is_on_floor() and not jump: #exit pongo stick
		release_action_active = false
		pongo_stick = false
		_jump_speed_moment = jump_speed
	elif not is_on_floor() and jump and release_action_active:
		_jump_speed_moment = jump_speed_super
		pongo_stick = true
	elif is_on_floor() and jump:
		_velocity.y = _jump_speed_moment
		set_collision_mask_bit(4, false)
		if not pongo_stick:
			$sp_player.play("idle")
		else:
			pass #anitmation pongo stick
	elif not is_on_floor() and not jump:
		release_action_active = true	

	if right:
		$sp_player.flip_h = false
		dir_shots = DIR_SHOSTS.RIGHT
		bullet_pos = _r_bullet_pos
		if not shots:
			_velocity.x += run_speed
	elif left:
		$sp_player.flip_h = true
		dir_shots = DIR_SHOSTS.LEFT
		bullet_pos = _l_bullet_pos
		if not shots:
			_velocity.x -= run_speed
	elif up:
		$sp_player.flip_h = true
		dir_shots = DIR_SHOSTS.UP
		bullet_pos = _up_bullet_pos
	

		
	if shots and can_fire:
		var _bullet = bullet.instance()
		_bullet.global_position = bullet_pos.global_position
		_bullet.set_direction(dir_shots)
		get_tree().get_root().add_child(_bullet)
		can_fire = false
		yield(get_tree().create_timer(fire_rate), "timeout")
		can_fire = true
	
func _process(delta):
	if $Camera2D.limit_bottom + 1500 < position.y:
		die()
	elif _pos_spawn.y < 0 and _pos_spawn.y + 500 <  position.y:
		die()
	
		
func _physics_process(delta):
	_get_input()
	if _health_moment > 0:
		var y  = get_viewport_transform().origin.y
		if y > (last_position_y + 200):
			last_position_y = y + 200
			take_score(score_jump)
		_velocity.y += gravty * delta
		if _velocity.y > 0:
			$sp_player.play("idle")
		else:
			$sp_player.play("jump")
		_velocity = move_and_slide(_velocity, Vector2(0, -1))

func _set_positon_about_visivilty_status():
	if position.x < 0:
		position.x = size_viewport.x + position.x
	elif position.x > size_viewport.x:
		position.x =  position.x - size_viewport.x


func desintegrated():
	if _health_moment > 0:
		_health_moment = 0
		lives -= 1
		$sp_player.visible = false
		$Particles2D.emitting = true
		$Particles2D.show()
		timer_on_air.stop()
		emit_signal("update_health", _health_moment)
		

func die():
	if _health_moment > 0:
		_health_moment = 0
		lives -= 1
		$sp_player.visible = false
		$Particles2D.emitting = true
		$Particles2D.show()
		timer_on_air.stop()
		emit_signal("update_health", _health_moment)

func _on_timer_on_air_timeout():
	if not _touch_floor:
		die()
	
