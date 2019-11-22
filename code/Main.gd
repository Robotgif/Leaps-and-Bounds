#warning-ignore-all:unused_variable
extends Node2D
onready var platform = preload("res://assests/platforms.tscn")


var camera: Camera2D = null
var player = null
var camera_pos = []
var platforms = []
var camera_size = null
var height = 0
var max_pos = 0
var pos_delete = []
var platforms_content = null

	
func _ready():
	camera = get_node("Player/Camera2D")
	player = get_node("Player")
	platforms_content = get_node("platforms_content")
	camera_pos = camera.get_camera_position()
	camera_size = camera.get_viewport_rect().size
	height = camera_size.y
	max_pos = platforms_content.position.y
	make_platform()
	
	

func _process(delta):
	camera_pos = camera.get_camera_position()
	if max_pos < 0 and max_pos >= camera_pos.y - 800:
		height += abs(max_pos)
		max_pos = camera_pos.y - 800
		make_platform()
	elif len(pos_delete) > 0 and pos_delete[0] >= camera_pos.y + 500:
		player.take_score(player.score_level)
		var pos = pos_delete.pop_front()
		player.set_spawn(pos)
		for p in platforms.pop_front():
			p.free()
		
		
		
func make_platform():
	var set_platform = []
	while abs(max_pos) < height + 1000:
		var p = platform.instance()
		var x = ceil(randf() *  (camera_size.x-260))
		if x < 100:
			x = 100
		max_pos -= 150
		p.position.x = x
		p.position.y = max_pos
		set_platform.append(p)
		platforms_content.add_child(p)
	platforms.append(set_platform)
	pos_delete.append(max_pos)
		

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
		update_lives()
	else:
		if get_tree().reload_current_scene() != OK:
				print_debug("An error occured when trying to reload the current scene at Level.gd.")



func _on_Player_update_score(score):
	$HUID.set_score(score)
	
func update_lives():
	$HUID.set_lives(player.lives)
