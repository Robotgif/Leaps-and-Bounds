#warning-ignore-all:unused_variable
extends Area2D

signal next_level

enum TYPE_PLATFORM {NEXT_LEVEL, INIT_LEVEL}

export (PackedScene) var next_level_path
export (NodePath) var node_transition = null
export (TYPE_PLATFORM) var type = TYPE_PLATFORM.NEXT_LEVEL

var player = null
var transition = null

func _ready():
	if type == TYPE_PLATFORM.INIT_LEVEL:
		$CollisionShape2D.disabled = true
		
	if node_transition != null:
		transition = get_node(node_transition)
		
func _on_next_level_body_entered(body):
	if "Player" in body.name and transition != null:
		player = body
		global.health = player.get_health()
		global.score = player.get_score() + player.get_score_level()
		global.lives = player.get_lives()
		player.queue_free()
		transition.interpolate_property(get_parent(), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 0.35,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		emit_signal("next_level")
		transition.start()
		$Timer.start()


func _on_Timer_timeout():
	assert(get_tree().change_scene(next_level_path.resource_path) == OK)
