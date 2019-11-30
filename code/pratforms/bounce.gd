extends KinematicBody2D

export var force_jump = -750

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		set_collision_mask_bit(1, true)
		if body.is_on_floor():
			body.touch_bounce(force_jump)
