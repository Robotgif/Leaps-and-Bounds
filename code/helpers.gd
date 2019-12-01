extends Node2D

export (NodePath) var huid_node

var huid

func _ready():
	if huid_node != null:
		huid = get_node(huid_node)

func _on_info_pongo_body_entered(body):
	huid.show_help(2)


func _on_info_controls_body_entered(body):
	huid.show_help(1)


func _on__body_exited(body):
	huid.show_help(0)

