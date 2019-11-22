#warning-ignore-all:unused_variable
extends CanvasLayer

func set_score(score):
	$score.text = str(score)

func set_lives(lives):
	var i =  $lives.get_child_count() - lives
	for l in $lives.get_children():
		if i > 0:
			l.visible = false
			i -= 1
					
func set_health(health):
	pass