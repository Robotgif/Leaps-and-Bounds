extends KinematicBody2D

signal update_health
signal update_score


export (int) var run_speed = 300
export (int) var gravty = 1500
export (int) var jump_speed = -1000
export (int) var jump_speed_super = -1300
export (int) var score_level = 1000
export (int) var score_jump = 10
export (int) var lives = 10
export (int) var health = 100
export (float) var fire_rate = .2

var bullet = preload("res://assests/shots.tscn")
var _score = 0
var _jump_speed_moment = jump_speed
var _health_moment = health
var _velocity = Vector2()
var size_viewport = null
var last_position_y = 0
var _pos_spawn = Vector2.ZERO
var can_fire = true

func set_spawn(pos):
	_pos_spawn = Vector2(size_viewport.x / 2, pos)
	
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

func _get_input():
	_set_positon_about_visivilty_status()
	_velocity.x = 0
	var left = Input.is_action_pressed("left")
	var right = Input.is_action_pressed("right")
	var up = Input.is_action_pressed("up") 
	var shots = Input.is_action_pressed("shots")
	var jump = Input.is_action_pressed("jump")
	var super_jump = Input.is_action_pressed("down")
	
	_jump_speed_moment = jump_speed if not super_jump else jump_speed_super
	
	if is_on_floor() and jump:
		_velocity.y = _jump_speed_moment
		set_collision_mask_bit(4, false)
		$sp_player.play("idle")
	else:
		pass
		
	if right and not shots:
		_velocity.x += run_speed
	elif left and not shots:
		_velocity.x -= run_speed
		
	elif shots and can_fire:
		var _bullet = bullet.instance()
		if left:
			_bullet.position = position + $positions_shots/left_pos.position
			_bullet.set_direction(0)
		elif right:
			_bullet.position = position + $positions_shots/right_pos.position
			_bullet.set_direction(1) 
		elif up:
			_bullet.position = position + $positions_shots/up_pos.position
			_bullet.set_direction(2)
		if left or right or up:
			
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
		emit_signal("update_health", _health_moment)

func die():
	if _health_moment > 0:
		_health_moment = 0
		lives -= 1
		$sp_player.visible = false
		$Particles2D.emitting = true
		$Particles2D.show()
		emit_signal("update_health", _health_moment)


	
	
	

	