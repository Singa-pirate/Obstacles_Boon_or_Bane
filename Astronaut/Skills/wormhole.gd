extends Node2D


var player
var speed
var new_pos


func _process(delta):
	if Input.is_action_just_pressed("wormhole_new_pos"):
		new_pos = get_global_mouse_position()
		print("position determined")
	if Input.is_action_just_released("wormhole_new_pos"):
		print("velocity determined")
		player.wormhole_reappear(new_pos, (get_global_mouse_position() - new_pos).normalized() * speed)
		queue_free()
