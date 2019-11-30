extends KinematicBody2D

onready var timer_gone = $timers/timer_gone
onready var timer_destroy = $timers/timer_destroy

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		set_collision_mask_bit(1, true)
		if body.is_on_floor():
			timer_gone.start()
			

func _on_timer_gone_timeout():
	$img.visible = false
	$collider.disabled = true
	$particles.emitting = true
	timer_destroy.start()


func _on_timer_destroy_timeout():
	queue_free()
