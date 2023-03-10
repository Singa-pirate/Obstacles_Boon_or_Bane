extends KinematicBody2D

const MAX_HEALTH = 100
const INIT_SPEED = 100
const ENEMY_ACTIVE_SLOW_SPEED_COEFFICIENT = 0.1
const EDGE_ACTIVE_SLOW_SPEED_COEFFICIENT = 0.01
const PORTAL_ACTIVE_SLOW_SPEED_COEFFICIENT = 0.5
const INIT_ANGULAR_SPEED = 30
const MAX_CHARGE = 10
const MIN_CHARGE = -10
const MAX_SPEED = 200
const FORCE_COEFFICIENT = 10

const MIN_X = -1000
const MAX_X = 10000
const MIN_Y = -1000
const MAX_Y = 10000
const PORTAL_ATTRACT_RANGE = 100

const SABER_DAMAGE = 10

var direction
var angular_speed = 0
var velocity
var health
var charge
var label
var mouse_hovering = false
var nearby_charges = []
var nearby_blackholes = []
var nearby_enemies = []
var is_visible = true
var mutable_name = "Player"
var is_invincible = false


var portal

var saber_cooldown = 1
var saber_ready = true

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH
	charge = 0
	direction = get_parent().astronaut_direction
	velocity = Vector2(0,0)
	label = get_node("ChargeLabel")
	$AnimationPlayer.get_animation("EnterPortal").track_set_key_value(0, 0, scale)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(velocity)
	if mouse_hovering:
		if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_released("ui_scroll_up")) and charge < MAX_CHARGE:
			charge += 1
			update_charge()
		if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_scroll_down")) and charge > MIN_CHARGE:
			charge -= 1
			update_charge()
	velocity = lerp(velocity, velocity.normalized() * INIT_SPEED, 0.005)
	change_velocity()
	if check_near_portal():
		var target_velocity = (portal.position - position).normalized() * INIT_SPEED \
								* PORTAL_ACTIVE_SLOW_SPEED_COEFFICIENT
		velocity = lerp(velocity, target_velocity, 0.01)		
	elif check_near_edge():
		actively_slow(EDGE_ACTIVE_SLOW_SPEED_COEFFICIENT)
	elif !nearby_enemies.empty():
		 actively_slow(ENEMY_ACTIVE_SLOW_SPEED_COEFFICIENT)
	move_and_slide(velocity)
	
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
	
func check_near_portal():
	portal = get_tree().get_nodes_in_group("Portal")[0]
	if (portal.position - position).length() < PORTAL_ATTRACT_RANGE:
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
	for obj in nearby_enemies:
		if obj.is_in_group("EnemiesWithHealth"):
			print("Saber Attack!")
			obj.take_damage(SABER_DAMAGE)
		
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
	#print(damage)
	if not is_invincible:
		$AnimationPlayer.play("TakeDamage")
		health -= damage
		is_invincible = true
		$Timers/InvincibilityTimer.start()
		
func _on_Charge_detector_area_entered(area):
	if area.get_class() == "blackhole":
		nearby_blackholes.append(area)

func _on_Charge_detector_area_exited(area):
	if area.get_class() == "blackhole":
		nearby_blackholes.erase(area)

func _on_NearbyObjectsDetector_body_entered(body):
	if body.is_in_group("Enemies"):
		nearby_enemies.append(body)

func _on_NearbyObjectsDetector_body_exited(body):
	if body.is_in_group("Enemies"):
		nearby_enemies.erase(body)
		
func _on_InvisibilityTimer_timeout():
	if !is_visible:
		toggle_visibility()

func _on_SaberTimer_timeout():
	saber_ready = true

func _on_Hurtbox_body_entered(body):
	if body.is_in_group("Enemies") or body.is_in_group("ObstaclesWithDamage"):
		var target_velocity = (position - body.position).normalized() * INIT_SPEED / 10
		velocity = lerp(velocity, target_velocity, 0.2)
		take_damage(body.damage)

func _on_InvincibilityTimer_timeout():
	is_invincible = false

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "EnterPortal":
		visible = false
