#warning-ignore-all:unused_variable
extends CanvasLayer

onready var bar = $TextureProgress
onready var score_node = $score
onready var lives_node = $lives

func set_max_value(health):
	bar.max_value = health

func set_score(score):
	score_node.text = str(score)

func set_lives(lives):
	var i =  lives_node.get_child_count() - lives
	for l in lives_node.get_children():
		if i > 0:
			l.visible = false
			i -= 1
					
func set_health(health):
	bar.value = health