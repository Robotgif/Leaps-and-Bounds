extends StaticBody2D

enum TYPES_PLATFORMS {BREAKABLE, SHORT, LONG}

export (TYPES_PLATFORMS) var type  = TYPES_PLATFORMS.LONG 

func _ready():
	if type == TYPES_PLATFORMS.BREAKABLE:
		$collider_long.disabled = false
		$breakable.visible = true
	elif type == TYPES_PLATFORMS.SHORT:
		$collider_short.disabled = false
		$short.visible = true
	elif type == TYPES_PLATFORMS.LONG:
		$collider_long.disabled = false
		$long.visible = true