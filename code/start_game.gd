extends Node2D

onready var button_start = $CanvasLayer/TextureRect/start
onready var obj = $CanvasLayer/TextureRect

	
func _on_start_mouse_entered():
	button_start.add_color_override("font_color", Color(0.3, 0.3, 0.3))
	button_start.add_color_override("font_color_shadow", Color(0.8, 0.8, 0.8))

func _process(_delta):
	if obj.modulate.a <= 0:
		assert(get_tree().change_scene("res://scenes/level01.tscn") == OK)

func _on_start_mouse_exited():
	button_start.add_color_override("font_color", Color(0, 0, 0))
	button_start.add_color_override("font_color_shadow", Color(0.61, 0.61, 0.61))


func _on_start_pressed():
	$Tween.interpolate_property(obj, "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.2,
	Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()


