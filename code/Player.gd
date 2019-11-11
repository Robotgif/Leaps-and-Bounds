extends KinematicBody2D

signal update_health
signal update_score

export (int) var run_speed = 500
export (int) var gravty = 1500
export (int) var jump_speed = -1000
export (int) var score_level = 1000
export (int) var score_jump = 10
export (int) var lives = 3
export (int) var health = 100


var _score = 0
var _jump_speed_moment = jump_speed
var _velocity = Vector2()
var size_viewport = null
var last_position_y = 0


func take_damage(damage):
	health -= damage
	emit_signal("update_health", health)

	
func take_score(score):
	_score += score
	emit_signal("update_score", _score)

	
func _ready():
	size_viewport = get_node("Camera2D").get_viewport_rect().size
	

func _get_input():
	_set_positon_about_visivilty_status()
	_velocity.x = 0
	var left = Input.is_action_pressed("move_left")
	var right = Input.is_action_pressed("move_right")
	if is_on_floor():
		_velocity.y = _jump_speed_moment
		set_collision_mask_bit(4, false)
		$sp_player.play("idle")
	else:
		pass #$sp_player.play("jump")
		
	if right:
		_velocity.x += run_speed
	if left:
		_velocity.x -= run_speed
	


func _physics_process(delta):
	_get_input()
	if health > 0:
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
		position.x = 0 + position.x - size_viewport.x


func desintegrated():
	health = 0
	$sp_player.visible = false
	$Particles2D.set_emitting(true)
	$Particles2D.show()
	emit_signal("update_health", health)

	