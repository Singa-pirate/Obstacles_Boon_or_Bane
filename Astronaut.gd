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
var mouse_hovering = false
var nearby_charges = []

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	charge = 0
	direction = Vector2(1,0) # TODO: ask parent
	velocity = Vector2(0,0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mouse_hovering:
		if Input.is_action_just_pressed("ui_up") and charge < MAX_CHARGE:
			charge += 1
		if Input.is_action_just_pressed("ui_down") and charge > MIN_CHARGE:
			charge -= 1
	if charge >= 0:
		get_node("ChargeLabel").text = "+" + str(charge)
	else:
		get_node("ChargeLabel").text = str(charge)
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
	print(acceleration)
	velocity += acceleration
	
	var ratio = float(velocity.length()) / MAX_SPEED
	if ratio > 1:
		velocity /= ratio	
	
func start():
	velocity = INIT_SPEED * direction
	angular_speed = INIT_ANGULAR_SPEED
	
func _on_Charge_detector_body_entered(body):
	print("yo")
	if body != self && body.get_class() == "charged":
		print("working!")
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
