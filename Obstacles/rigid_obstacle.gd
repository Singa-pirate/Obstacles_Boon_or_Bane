extends RigidBody2D


var charge = 0
const UPPER_BOUND = 10
const LOWER_BOUND = -10

var mouse_hovering = false


func _physics_process(delta):
	if mouse_hovering:
		if Input.is_action_just_pressed("ui_up") and charge < UPPER_BOUND:
			charge += 1
		if Input.is_action_just_pressed("ui_down") and charge > LOWER_BOUND:
			charge -= 1


func _on_Area2D_mouse_entered():
	mouse_hovering = true


func _on_Area2D_mouse_exited():
	mouse_hovering = false
