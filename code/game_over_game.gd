extends Node2D

onready var obj = $CanvasLayer/TextureRect

func _ready():
	$Tween.interpolate_property(obj, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 5,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _process(_delta):
	if obj.modulate.a <= 0:
		assert(get_tree().change_scene("res://scenes/start_game.tscn") == OK)
