extends Node2D
onready var platform = preload("res://templates/Platform.tscn")

var bounds = {
	'left': 0,
	'right': 0,
	'button':0,
	}

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
	platforms_content = get_node("platforms")
	camera_pos = camera.get_camera_position()
	camera_size = camera.get_viewport_rect().size
	height = camera_size.y
	max_pos = camera_pos.y
	make_platform()
	
	

func _process(delta):
	camera_pos = camera.get_camera_position()
	if max_pos < 0 and max_pos >= camera_pos.y - 500:
		height += abs(max_pos)
		max_pos = camera_pos.y - 500
		make_platform()
	elif len(pos_delete) > 0 and pos_delete[0] >= camera_pos.y + 500:
		player.add_score()
		pos_delete.pop_front()
		for p in platforms.pop_front():
			p.free()
		
		
		
func make_platform():
	var set_platform = []
	while abs(max_pos) < height + 1000:
		var p = platform.instance()
		var x = ceil(randf() *  camera_size.x)
		max_pos -= 150
		p.position.x = x
		p.position.y = max_pos
		set_platform.append(p)
		platforms_content.add_child(p)
	platforms.append(set_platform)
	pos_delete.append(max_pos)
		
		
		
		
			
	
