#warning-ignore-all:unused_variable
extends Node2D

export var auto_generate: bool = true

var player = null
# Called when the node enters the scene tree for the first time.
func _ready():
	player = global.player

func _physics_process(delta):
	if auto_generate:
		position.y = player.position.y - 200



func _on_bounds_right_body_entered(body):
	if body.get_name() == "Player":
		body.desintegrated()


func _on_bounds_left_body_entered(body):
	if body.get_name() == "Player":
		body.desintegrated()
