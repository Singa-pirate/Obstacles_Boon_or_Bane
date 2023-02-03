extends KinematicBody2D

const MAX_HEALTH = 100
const INIT_SPEED = 100
const INIT_ANGULAR_SPEED = 30
const MAX_CHARGE = 10
const MIN_CHARGE = -10
const MAX_SPEED = 200
const coefficient = 2

var direction
var angular_speed = 0
var velocity
var health
var charge
var label
var mouse_hovering = false
var nearby_charges = []

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	charge = 0
	direction = Vector2(1,0) # TODO: ask parent
	velocity = Vector2(0,0)
	label = get_node("ChargeLabel")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_hovering:
		if Input.is_action_just_pressed("ui_up") and charge < MAX_CHARGE:
			charge += 1
			update_charge()
		if Input.is_action_just_pressed("ui_down") and charge > MIN_CHARGE:
			charge -= 1
			update_charge()
	velocity = lerp(velocity, velocity.normalized() * INIT_SPEED, 0.01)
	change_velocity()
	position += velocity * delta
	rotation_degrees += angular_speed * delta

func change_velocity():
	var acceleration = Vector2.ZERO;
	for ch in nearby_charges:
		var vector = ch.position - position
		if vector.length() == 0:
			continue
		var strength = - coefficient * charge * ch.charge / vector.length() / vector.length()
		acceleration += vector * strength
	velocity += acceleration
	
	var ratio = float(velocity.length()) / MAX_SPEED
	if ratio > 1:
		velocity /= ratio	
	
func start():
	velocity = INIT_SPEED * direction
	angular_speed = INIT_ANGULAR_SPEED
	
func _on_Charge_detector_body_entered(body):
	if body != self && body.get_class() == "charged":
		nearby_charges.append(body)

func _on_Charge_detector_body_exited(body):
	if body != self && body.get_class() == "charged":
		nearby_charges.erase(body)
		
func _on_Hitbox_mouse_entered():
	mouse_hovering = true

func _on_Hitbox_mouse_exited():
	mouse_hovering = false

func get_class():
	return "charged"

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
		
