extends Node2D

## Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("impact")
	
func show_mode(rot, _scale):
	scale.x = _scale
	rotation_degrees = rot
	