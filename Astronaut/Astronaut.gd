extends CharacterBody2D

const MAX_HEALTH = 100
const INIT_SPEED = 100
const ENEMY_ACTIVE_SLOW_SPEED_COEFFICIENT = 0
const EDGE_ACTIVE_SLOW_SPEED_COEFFICIENT = 0.01
const PORTAL_ACTIVE_SLOW_SPEED_COEFFICIENT = 0.5
const INIT_ANGULAR_SPEED = 30
const MAX_CHARGE = 10
const MIN_CHARGE = -10
const MAX_SPEED = 200
const FORCE_COEFFICIENT = 10
const PLANET_COLLISION_DAMAGE_COEFFICIENT = 0.3
const FLYING_ANIMATION_SPEED_THRESHOLD = 20

const MIN_X = -1000
const MAX_X = 10000
const MIN_Y = -1000
const MAX_Y = 10000
const PORTAL_ATTRACT_RANGE = 100

const SABER_DAMAGE = 10

# properties
var direction
var health
var charge
var is_visible = true
var is_invincible = false
var mutable_name = "Player"

# charge
var label
var mouse_hovering = false

# environment
var nearby_charges = []
var nearby_blackholes = []
var nearby_enemies = []

var portal

# skills
var saber_cooldown = 1
var saber_ready = true

var action_lock
var movement_animation_lock = false
var flying_animation_speed_threshold = 20
var was_idle = true

var health_regen_available = false # initially true if the skill is available in the level
var health_constant = 1
var skill_constant = 2
var health_regen_amount = 40

var wormhole_available = false # initially true if the skill is available in the level
var wormhole_threshold = 60
const WormHole = preload("res://Astronaut/Skills/WormHole.tscn")

var tanks = []
const BigTank = preload("res://Astronaut/Side Characters/BigTank.tscn")
const SmallTank = preload("res://Astronaut/Side Characters/SmallTank.tscn")
const tank_offset = 50


func add_big_tank():
	for tank in tanks:
		tank.queue_free()
	tanks.clear()
	var big_tank = BigTank.instantiate()
	big_tank.position = tank_offset * direction
	add_child(big_tank)
	tanks.append(big_tank)


func add_small_tanks(number):
	for tank in tanks:
		tank.queue_free()
	tanks.clear()
	var angle_increment = 2 * PI / number
	for i in range(number):
		var small_tank = SmallTank.instantiate()
		var angle = Vector2.RIGHT.angle_to(direction) + angle_increment * i
		small_tank.position = tank_offset * Vector2(cos(angle), sin(angle))
		add_child(small_tank)
		tanks.append(small_tank)


func orient_tanks(angle):
	var angle_increment = 2 * PI / tanks.size()
	for i in range(tanks.size()):
		var this_angle = angle + angle_increment * i
		tanks[i].rotation_degrees = rad_to_deg(this_angle)
		tanks[i].position = tank_offset * Vector2(cos(this_angle), sin(this_angle))


"""Initialization"""
# Called when the node enters the scene tree for the first time.
func _ready():
	action_lock = true
	health = MAX_HEALTH
	charge = 0
	direction = get_parent().astronaut_direction
	velocity = Vector2(0,0)
	label = get_node("ChargeLabel")
	$EnterPortal.get_animation("Animations/EnterPortal").track_set_key_value(0, 0, scale)
	$Appearance.play("Idle")

## called when start button is pressed
func start():
	velocity = INIT_SPEED * direction
	action_lock = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (health <= 0):
		die()

	# Update charge
	if mouse_hovering or Input.is_action_pressed("ui_shift"):
		if (Input.is_action_just_pressed("ui_up") or Input.is_action_just_released("ui_scroll_up")) and charge < MAX_CHARGE:
			charge += 1
			update_charge()
		if (Input.is_action_just_pressed("ui_down") or Input.is_action_just_released("ui_scroll_down")) and charge > MIN_CHARGE:
			charge -= 1
			update_charge()

	if (not action_lock):
		# Self Healinkg
		
		if velocity.x > 10:
			if $Appearance.flip_h == true:
				$Appearance.flip_h = false
				if not $SaberAttack.is_playing() && $Saber.frame < 22:
					$Saber.flip_h = false
		elif velocity.x < -10:
			if $Appearance.flip_h == false:
				$Appearance.flip_h = true
				if not $SaberAttack.is_playing() && $Saber.frame < 22:
					$Saber.flip_h = true
		# Active movement
		if check_near_portal():
			var target_velocity = (portal.position - position).normalized() * INIT_SPEED \
									* PORTAL_ACTIVE_SLOW_SPEED_COEFFICIENT
			velocity = lerp(velocity, target_velocity, 0.01)
		elif check_near_edge():
			actively_slow(EDGE_ACTIVE_SLOW_SPEED_COEFFICIENT)
		elif !nearby_enemies.is_empty():
			actively_slow(ENEMY_ACTIVE_SLOW_SPEED_COEFFICIENT)
		else:
			# Passive movement
			velocity = lerp(velocity, velocity.normalized() * INIT_SPEED, 0.005)
			if get_last_slide_collision():
				velocity = Vector2.ZERO
			if get_floor_normal():
				velocity = Vector2.ZERO;
			change_velocity()

		# Move!
		set_velocity(velocity)
		if velocity.length() > FLYING_ANIMATION_SPEED_THRESHOLD and not movement_animation_lock:
			if was_idle:
				was_idle = false
				play_movement_animation("TakingOff")
			else:
				$Appearance.play("Flying")
		elif velocity.length() < FLYING_ANIMATION_SPEED_THRESHOLD:
			was_idle = true
			play_movement_animation("Idle")
			
		move_and_slide()
		
		orient_tanks(Vector2.RIGHT.angle_to(direction))

		if !nearby_enemies.is_empty() and saber_ready: #enemies nearby
			saber_attack()

		if wormhole_available:
			var activate_wormhole = false
			for ch in nearby_charges:
				var product = abs(ch.charge * charge)
				if product >= wormhole_threshold:
					activate_wormhole = true
					break
			if activate_wormhole:
				wormhole_disappear()
		
		if health_regen_available:
			if Input.is_action_just_pressed("health_regen"):
				health_regen()

"""Passive movement due to environment"""
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
	direction = velocity.normalized()

	# cap at max speed
	var ratio = float(velocity.length()) / MAX_SPEED
	if ratio > 1:
		velocity /= ratio

func play_movement_animation(anim_name):
	movement_animation_lock = true
	$Appearance.play(anim_name)

func _on_Charge_detector_body_entered(body):
	if body != self && body.is_in_group("ObstaclesWithCharge"):
		nearby_charges.append(body)

func _on_Charge_detector_body_exited(body):
	if body != self && body.is_in_group("ObstaclesWithCharge"):
		nearby_charges.erase(body)

func _on_Charge_detector_area_entered(area):
	if area.is_in_group("BlackHole"):
		nearby_blackholes.append(area)

func _on_Charge_detector_area_exited(area):
	if area.is_in_group("BlackHole"):
		nearby_blackholes.erase(area)


"""Active Movement"""
func actively_slow(coefficient):
	play_movement_animation("SlowingDown")
	velocity = lerp(velocity, velocity.normalized() * INIT_SPEED * coefficient, 0.02)

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

"""Skills"""
# invisibility
func toggle_visibility():
	if is_visible:
		mutable_name = "Invisible"
		name = mutable_name
		$Appearance.modulate.a = 0.5
		$Timers/InvisibilityTimer.start()
	else:
		mutable_name = "Player"
		name = mutable_name
		$Appearance.modulate.a = 1
	is_visible = !is_visible

#saber
func saber_attack():
	saber_ready = false
	var attacking = false
	for obj in nearby_enemies:
		if obj.is_in_group("EnemiesWithHealth"):
			attacking = true
			obj.take_damage(SABER_DAMAGE)
	if attacking:
		$Saber.visible = true
		$Saber.frame = 0
		$Saber.play("attack")
		$SaberAttack.play("Animations/SaberAttack")
		$Timers/SaberTimer.wait_time = saber_cooldown
		$Timers/SaberTimer.start()


func wormhole_disappear():
	wormhole_available = false
	$Appearance.modulate.a = 0
	$ChargeLabel.modulate.a = 0
	var wormhole = WormHole.instantiate()
	wormhole.player = self
	wormhole.speed = INIT_SPEED
	get_parent().add_child(wormhole)
	set_process_mode(4)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)


func wormhole_reappear(p, v):
	position = p
	velocity = v
	$Appearance.modulate.a = 1
	$ChargeLabel.modulate.a = 1
	set_process_mode(0)
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)


func health_regen():
	health = min(health + health_regen_amount, MAX_HEALTH)
	health_constant = skill_constant
	$Timers/HealthRegenTimer.start()


func _on_NearbyObjectsDetector_body_entered(body):
	if body.is_in_group("Enemies"):
		nearby_enemies.append(body)

func _on_NearbyObjectsDetector_body_exited(body):
	if body.is_in_group("Enemies"):
		nearby_enemies.erase(body)


"""Player control (updating charge)"""
func _on_Hitbox_mouse_entered():
	mouse_hovering = true


func _on_Hitbox_mouse_exited():
	mouse_hovering = false


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

"""Taking damage"""
func take_damage(damage):
	if not is_invincible:
		$TakeDamage.play("Animations/TakeDamage")
		health -= health_constant * damage
		is_invincible = true
		$Timers/InvincibilityTimer.start()

func collide_with_planet():
	take_damage(velocity.length() * PLANET_COLLISION_DAMAGE_COEFFICIENT)
	#v_fixed_at_zero = true

func _on_Hurtbox_body_entered(body):
	if body.is_in_group("Planets"):
		collide_with_planet()
	elif body.is_in_group("Enemies") or body.is_in_group("ObstaclesWithDamage"):
		var target_velocity = (position - body.position).normalized() * INIT_SPEED / 10
		velocity = lerp(velocity, target_velocity, 0.2)
		take_damage(body.damage)

func die():
	# TODO: die animation & Game Over scene
	action_lock = true
	queue_free()


"""Timers"""
func _on_InvisibilityTimer_timeout():
	if !is_visible:
		toggle_visibility()

func _on_SaberTimer_timeout():
	$Saber.visible = false
	saber_ready = true

func _on_InvincibilityTimer_timeout():
	is_invincible = false

func _on_health_regen_timer_timeout():
	health_constant = 1

"""Animations"""
func enter_portal():
	$EnterPortal.play("Animations/EnterPortal")

func _on_take_damage_animation_finished(anim_name):
	if anim_name == "Animations/EnterPortal":
		visible = false
		
func _on_appearance_animation_looped():
	movement_animation_lock = false
	
