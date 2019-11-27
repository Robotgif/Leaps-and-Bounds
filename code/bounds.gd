#warning-ignore-all:unused_variable
extends Node2D

func _physics_process(delta):
	if global.player != null:
		var wr = weakref(global.player)
		if wr.get_ref():
			position.y = global.player.position.y
		

func _on_bounds_right_body_entered(body):
	if body.get_name() == "Player":
		body.desintegrated()

func _on_bounds_left_body_entered(body):
	if body.get_name() == "Player":
		body.desintegrated()
