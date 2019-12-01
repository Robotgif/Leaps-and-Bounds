extends Node

#warning-ignore-all:unused_variable

var player = null setget set_player
var score = 0
var lives = 3
var health = 0
var level = 1

func set_player(p):
	if player == null:
		score = p.get_score()
		lives = p.get_lives()
		health = p.get_health()
	player = p
	
func add_level():
	level += 1