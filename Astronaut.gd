extends KinematicBody2D

const MAX_HEALTH = 100
const INIT_SPEED = 100
const ENEMY_ACTIVE_SLOW_SPEED_COEFFICIENT = 0.1
const EDGE_ACTIVE_SLOW_SPEED_COEFFICIENT = 0.01
const INIT_ANGULAR_SPEED = 30
const MAX_CHARGE = 10
const MIN_CHARGE = -10
const MAX_SPEED = 200
const FORCE_COEFFICIENT = 10

const MIN_X = -1000
const MAX_X = 10000
const MIN_Y = -1000
const MAX_Y = 10000


var direction
var angular_speed = 0
var velocity
var health
var charge
var label
var mouse_hovering = false
var nearby_charges = []
var nearby_blackholes = []
var nearby_objects = []
var is_visible = true
var mutable_name = "Player"

var saber_cooldown = 1
var saber_ready = true

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	charge = 0
	direction = get_parent().astronaut_direction
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
	if check_near_edge():
		actively_slow(EDGE_ACTIVE_SLOW_SPEED_COEFFICIENT)
	if !nearby_objects.empty():
		 actively_slow(ENEMY_ACTIVE_SLOW_SPEED_COEFFICIENT)
	change_velocity()
	position += velocity * delta
	
	if true and saber_ready: #enemies nearby
		saber_attack()

func change_velocity():
	# acceleration due to charge
	var acceleration = Vector2.ZERO;
	for ch in nearby_charges:
		var vector = ch.position - position
		if vector.length() == 0:
			continue
		var strength = - FORCE_COEFFICIENT * charge * ch.charge / vector.length() / vector.length()
		acceleration += vector * strength
	
	# acceleration due to blackholes
	for blackhole in nearby_blackholes:
		var vector = blackhole.position - position
		if vector.length() == 0:
			continue
		acceleration += vector * blackhole.strength
	
	# change velocity
	velocity += acceleration
	
	# cap at max speed
	var ratio = float(velocity.length()) / MAX_SPEED
	if ratio > 1:
		velocity /= ratio
		
func actively_slow(coefficient):
	velocity = lerp(velocity, velocity.normalized() * INIT_SPEED * coefficient, 0.05)
	
func check_near_edge():
	if abs(position.x - MIN_X) < 50 || abs(position.x - MAX_X) < 50:
		return true
	if abs(position.y - MIN_Y) < 50 || abs(position.y - MAX_Y) < 50:
		return true
	return false
	
func toggle_visibility():
	if is_visible:
		mutable_name = "Invisible"
		name = mutable_name
		$Sprite.modulate.a = 0.5
		$Timers/InvisibilityTimer.start()
	else:
		mutable_name = "Player"
		name = mutable_name
		$Sprite.modulate.a = 1
	is_visible = !is_visible
	
func saber_attack():
	saber_ready = false
	# Attack!
	$Timers/SaberTimer.wait_time = saber_cooldown	
	$Timers/SaberTimer.start()
	
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

func take_damage(damage):
	# TODO
	pass

func _on_Charge_detector_area_entered(area):
	if area.get_class() == "blackhole":
		nearby_blackholes.append(area)

func _on_NearbyObjectsDetector_body_entered(body):
	if body != self:
		nearby_objects.append(body)

func _on_NearbyObjectsDetector_body_exited(body):
	if body != self:
		nearby_objects.erase(body)
		
func _on_InvisibilityTimer_timeout():
	if !is_visible:
		toggle_visibility()

func _on_SaberTimer_timeout():
	saber_ready = true
