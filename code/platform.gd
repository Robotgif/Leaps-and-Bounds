#warning-ignore-all:unused_variable
extends Node2D

var collider = null

enum TYPES_PLATFORMS {BREAKABLE, SHORT, LONG, MOVING}

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
		collider = $breakable
	elif type == TYPES_PLATFORMS.SHORT:
		$short.visible = true
		$short/collider.disabled = false
		collider = $short
	elif type == TYPES_PLATFORMS.LONG:
		$long.visible = true
		$long/collider.disabled = false
		collider = $long
	elif type == TYPES_PLATFORMS.MOVING:
		$AnimationPlayer.play("left_right")
		$breakable.visible = true
		$breakable/collider.disabled = false
		collider = $breakable

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		collider.set_collision_mask_bit(1, true)
		if type == TYPES_PLATFORMS.BREAKABLE and body.is_on_floor():
			$breakable/timer_gone.start()
		
func _on_timer_gone_timeout():
	$breakable/collider.disabled = true
	$breakable/particles.emitting = true
	$breakable/img.visible = false
			
	
	
