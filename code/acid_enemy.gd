extends KinematicBody2D

onready var timer_gone = $timers/timer_gone
onready var timer_particle = $timers/timer_particle

export var speed  = 20
export var lifetime = 10
export var damage = 10

var _velocity = Vector2()
var dir = Vector2()
var target = Vector2()


func _ready():
	if str(global.player) != "[Deleted Object]":
		target = Vector2(global.player.global_position.x, global.player.global_position.y)
		dir = (target - global_position).normalized()
	timer_gone.wait_time = lifetime
	timer_gone.start()
	
func _physics_process(delta):
	_velocity += dir * speed * delta
	_velocity = move_and_slide(_velocity, Vector2.UP)
	
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision and collision.collider:
			if "Player" in collision.collider.name:
				collision.collider.take_damage(damage)
			destroy()
	
func _on_Timer_timeout():
	queue_free()
	
func destroy():
	$CollisionShape2D.disabled = true
	$img.visible = false
	$particles.emitting = true
	timer_particle.start()


