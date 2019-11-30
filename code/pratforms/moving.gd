extends Node2D

onready var platform = $platform

enum MOVEMENT {LEFT_RIGHT, UP_DOWN, RIGHT_LEFT}

export (MOVEMENT) var movement = MOVEMENT.LEFT_RIGHT


func _ready():
	if movement == MOVEMENT.LEFT_RIGHT:
		$AnimationPlayer.play("left_right")
	elif movement == MOVEMENT.UP_DOWN:
		$AnimationPlayer.play("elevator")
	else:
		$AnimationPlayer.play("rigth_left")
		
func _on_Area2D_body_entered(body):
	if body.name == "Player":
		platform.set_collision_mask_bit(1, true)
