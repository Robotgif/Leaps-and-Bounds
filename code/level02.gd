#warning-ignore-all:unused_variable
extends Node2D

var _player = null

func _ready():
	_player = get_node("Player")
	global.player = _player
	_player.set_spawn(_player.position)
	_player.set_score(global.score)
	_player.set_lives(global.lives)
	_player.set_health(global.health)
	update_all()
	
func update_all():
	$HUID.set_lives(_player.get_lives())
	$HUID.set_score(_player.get_score())
	$HUID.set_health(_player.get_health())
	
func _on_Player_update_health(health):
	yield(get_tree().create_timer(.5), "timeout")
	$transition.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.35,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$transition.start()
	yield(get_tree().create_timer(.5), "timeout")
	if _player.lives > 0:
		_player.spawn()
		$transition.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$transition.start()
		update_all()
	else:
		assert(get_tree().reload_current_scene() == 0)
	
func _on_Player_update_score(score):
	$HUID.set_score(score)

func _on_fallen_body_entered(body):
	_player.die()

