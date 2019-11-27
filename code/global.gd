extends Node

#warning-ignore-all:unused_variable

var player = null setget set_player
var score = 0
var lives = 3
var health = -1

func set_player(p):
	if health < 0:
		score = p.get_score()
		lives = p.get_lives()
		health = p.get_health()
	player = p