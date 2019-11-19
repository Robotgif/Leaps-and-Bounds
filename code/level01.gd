extends Node2D

var player = null

func _ready():
	player = get_node("Player")
	player.set_spawn(player.position.y)
	

func _on_Player_update_health(health):
	yield(get_tree().create_timer(.5), "timeout")
	$transition.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.35,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$transition.start()
	yield(get_tree().create_timer(.5), "timeout")
	if player.lives > 0:
		player.spawn()
		$transition.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$transition.start()
		update_lives()
	else:
		if get_tree().reload_current_scene() != OK:
				print_debug("An error occured when trying to reload the current scene at Level.gd.")


func _on_Player_update_score(score):
	$HUID.set_score(score)
	
func update_lives():
	$HUID.set_lives(player.lives)


func _on_fallen_body_entered(body):
	player.die()
