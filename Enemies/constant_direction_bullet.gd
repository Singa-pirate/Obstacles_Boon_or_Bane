extends Area2D


var DAMAGE = 5 # to be changed

var unit_direction
const SPEED = 20


func _ready():
	$AnimatedSprite2D.play()
	rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(unit_direction))


func _physics_process(delta):
	position += SPEED * unit_direction


func _on_ConstantDirectionBullet_body_entered(body):
	if body.is_in_group("Character"):
		body.take_damage(DAMAGE)
