extends Area2D


const DAMAGE = 5

var unit_direction
const SPEED = 20

func _physics_process(delta):
	position += SPEED * unit_direction


func _on_ConstantDirectionBullet_body_entered(body):
	if body.is_in_group("Character"):
		body.take_damage(DAMAGE)
		print("inflicting damage")
