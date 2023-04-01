extends CharacterBody2D

# I DO NOT KNOW WHO WROTE THIS!!!
# WRITTEN BY GHOST!!!
#
#const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
#
## Get the gravity from the project settings to be synced with RigidBody nodes.
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
#
#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
#
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	var direction = Input.get_axis("ui_left", "ui_right")
#	if direction:
#		velocity.x = direction * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, SPEED)
#
#	move_and_slide()

var damage = 10 # to be replaced
var actual_speed = 2
var speed = 0 # to be replaced
var unit_direction = Vector2(-3.0/5, 4.0/5) # to be replaced


func _physics_process(delta):
	position += actual_speed * unit_direction


func _on_hit_box_body_entered(body):
	if body.name == "Astronaut":
		body.take_damage(damage)
