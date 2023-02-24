extends KinematicBody2D


var charge = 0
const UPPER_BOUND = 10
const LOWER_BOUND = -10
const DAMAGE = 5

var mouse_hovering = false
var label

func _ready():
	label = get_node("ChargeLabel")

func _physics_process(delta):
	if mouse_hovering:
		if Input.is_action_just_pressed("ui_up") and charge < UPPER_BOUND:
			charge += 1
			update_charge()
		if Input.is_action_just_pressed("ui_down") and charge > LOWER_BOUND:
			charge -= 1
			update_charge()
			
func update_charge():
	var c = float(charge) / 10
	if charge > 0:
		label.modulate = Color(1, 1 - c, 1 - c)
		label.text = "+" + str(charge)
	elif charge < 0:
		label.modulate = Color(1 + c, 1 + c, 1)
		label.text = str(charge)
	else:
		label.modulate = Color(1 ,1 ,1)
		label.text = "+0"
			
func get_class():
	return "charged"


func _on_Area2D_mouse_entered():
	mouse_hovering = true


func _on_Area2D_mouse_exited():
	mouse_hovering = false
