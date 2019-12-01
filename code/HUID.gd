#warning-ignore-all:unused_variable
extends CanvasLayer

export  (Array, Texture) var texturas
export (PackedScene) var icon_live

onready var bar = $TextureProgress
onready var score_node = $score
onready var lives_content = $content_lives/grid
onready var max_pongo_node = $pongo_stick/max_pongo
onready var info_controls = $helper/text_controls
onready var info_stick = $helper/pongo_stick

func _ready():
	var level = global.level
	$TextureRect.texture = texturas[level]
	if level == 1:
		$AnimatedSprite.global_position = $TextureRect/pos_uno.global_position
	elif level == 2:
		$AnimatedSprite.global_position = $TextureRect/pos_dos.global_position
	elif level == 3:
		$AnimatedSprite.global_position = $TextureRect/pos_tres.global_position
		
	
func clear_lives():
	for child in lives_content.get_children():
		child.queue_free()
		
func create_lives(lives):
	clear_lives()
	for l in range(0, lives):
		var _icon = icon_live.instance()
		lives_content.add_child(_icon)

func set_max_pongo(value):
	max_pongo_node.text = str(value)
	
func set_max_value(health):
	bar.max_value = health

func set_score(score):
	score_node.text = str(score)

func set_lives(lives):
	var i =  lives_content.get_child_count() - lives
	for l in lives_content.get_children():
		if i > 0:
			l.visible = false
			i -= 1
			
			
func set_health(health):
	bar.value = health
	
func show_help(num):
	if num == 1:
		info_controls.visible = true
	elif num == 2:
		info_stick.visible = true
	else:
		info_controls.visible = false
		info_stick.visible = false