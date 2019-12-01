extends Node2D
var one_time = true

func _on_Area2D_body_entered(body):
	if body.name == "Player" and one_time:
		one_time = false
		body.set_lives(body.get_lives() + 1)
		print("loculeo")
		$Particles2D.emitting = true
		$Timer.start()

func _on_Timer_timeout():
	queue_free()
