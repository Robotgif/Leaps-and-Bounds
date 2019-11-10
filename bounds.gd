extends Node2D

var player = null
# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_parent().get_node("Player")

func _physics_process(delta):
	position.y = player.position.y - 200



func _on_bounds_right_body_entered(body):
	if body.get_name() == "Player":
		body.desintegrated()


func _on_bounds_left_body_entered(body):
	if body.get_name() == "Player":
		body.desintegrated()
