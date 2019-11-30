extends StaticBody2D

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		set_collision_mask_bit(1, true)
	