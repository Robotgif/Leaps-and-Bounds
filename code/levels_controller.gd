#warning-ignore-all:unused_variable
extends Node2D

var player = null

func _ready():
	player = get_node("Player")
	player.set_spawn(player.global_position)
	global.player = player
	player.set_lives(global.lives)
	player.set_health(global.health)
	player.set_score(global.score)
	update_huid()
	
	
func update_huid():
	$HUID.set_lives(player.get_lives())
	$HUID.set_score(player.get_score())
	$HUID.set_health(player.get_health())

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
		update_huid()
	else:
		assert(get_tree().reload_current_scene() == OK)

func _on_Player_update_score(score):
	$HUID.set_score(score)
	
func _on_fallen_body_entered(body):
	player.die()
