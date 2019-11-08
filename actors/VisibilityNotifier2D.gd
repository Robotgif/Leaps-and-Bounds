extends VisibilityNotifier2D

var is_spawned = true

func _on_VisibilityNotifier2D_viewport_exited(viewport):
	if not is_spawned:
		var parent = get_parent()
		var size = viewport.get_visible_rect().size
		if parent.position.x < 0:
			parent.position.x = size.x + parent.position.x
		else:
			parent.position.x = 0 + parent.position.x - size.x
	
	else:
		is_spawned = false