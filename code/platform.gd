#warning-ignore-all:unused_variable
extends Node2D


enum TYPES_PLATFORMS {BREAKABLE, SHORT, LONG, MOVING, BOUNCE}

export (TYPES_PLATFORMS) var type  = TYPES_PLATFORMS.LONG
export var bounce_force = -1000

var collider = null

func disable_all():
	$breakable.visible = false
	$breakable/collider.disabled = true
	$short.visible = false
	$short/collider.disabled = true
	$long.visible = false
	$long/collider.disabled = true
	$moving.visible = false
	$moving/collider.disabled = true
	$bounce.visible = false
	$bounce/collider.disabled = true
	
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
		$moving.visible = true
		$moving/collider.disabled = false
		collider = $moving
	elif type == TYPES_PLATFORMS.BOUNCE:
		$bounce.visible = true
		$bounce/collider.disabled = false
		collider = $bounce

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		collider.set_collision_mask_bit(1, true)
		if type == TYPES_PLATFORMS.BREAKABLE:
			$breakable/timer_gone.start()
		if type == TYPES_PLATFORMS.BOUNCE:
			body.touch_bounce(bounce_force)
		
		
func _on_timer_gone_timeout():
	$breakable/collider.disabled = true
	$breakable/particles.emitting = true
	$breakable/img.visible = false
			
	
	
