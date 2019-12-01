#warning-ignore-all:unused_variable
extends Node2D

export var max_pongo_stick = 4

var player = null


func _ready():
	player = get_node("Player")
	player.set_spawn(player.global_position)
	global.player = player
	
	player.set_lives(global.lives)
	player.set_health(global.health)
	player.set_score(global.score)
	player.set_max_pongo(max_pongo_stick)
	$HUID.set_max_value(player.health)
	update_huid()
	
	player.spawn()
	$transition.interpolate_property(self, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 0.35,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$transition.start()
	
func update_huid():
	$HUID.set_lives(player.get_lives())
	$HUID.set_score(player.get_score())
	$HUID.set_health(player.get_health())
	$HUID.set_max_pongo(max_pongo_stick)
	global.lives = player.get_lives()
	global.score = player.get_score()
	global.health = player.get_health()
	
func _on_Player_update_health(health):
	if health > 0:
		$HUID.set_health(player.get_health())
		global.health = player.get_health()
	else:
		$transition.interpolate_property(self, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		$transition.start()
		$Timer.start()
		
func _on_Player_update_score(score):
	$HUID.set_score(score)
	global.score = score
	
func _on_fallen_body_entered(body):
	if body.name == "Player":
		player.die()

func _on_Timer_timeout():
	if player.lives > 0:
		update_huid()
		global.health = player.health
		assert(get_tree().reload_current_scene() == OK)
	else:
		assert(get_tree().change_scene("res://scenes/game_over_game.tscn") == OK)

func _on_Player_update_pongo(value):
	$HUID.set_max_pongo(value)

func _on_next_level_next_level():
	global.add_level()

func _on_AudioStreamPlayer2D_finished():
	$AudioStreamPlayer2D.play()
