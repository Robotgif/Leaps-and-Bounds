extends Node2D

enum TYPES_PLATFORMS {BREAKABLE, SHORT, LONG}

export (TYPES_PLATFORMS) var type  = TYPES_PLATFORMS.LONG

func disable_all():
	$breakable.visible = false
	$breakable/collider.disabled = true
	$short.visible = false
	$short/collider.disabled = true
	$long.visible = false
	$long/collider.disabled = true

func _ready():
	disable_all()
	if type == TYPES_PLATFORMS.BREAKABLE:
		$breakable.visible = true
		$breakable/collider.disabled = false
		$breakable/dectect_collision.monitoring = true
	elif type == TYPES_PLATFORMS.SHORT:
		$short.visible = true
		$short/collider.disabled = false
	elif type == TYPES_PLATFORMS.LONG:
		$long.visible = true
		$long/collider.disabled = false

func _on_timer_timeout():
	pass


func _on_Area2D_body_entered(body):
	$breakable/particles.emitting = true
	yield(get_tree().create_timer(2), "timeout")
	free()
