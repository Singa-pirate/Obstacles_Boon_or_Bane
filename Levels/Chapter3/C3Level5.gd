extends Node2D


var astronaut_direction = Vector2.UP


func _ready():
	$Astronaut.wormhole_available = true
	$Astronaut.health_regen_available = true
	$ConstantDirection.unit_direction = Vector2(-4, -1).normalized()
	$ConstantDirection.bullet_damage = 40
	$ConstantDirection2.unit_direction = Vector2.UP
	$ConstantDirection2.bullet_damage = 50
	$ConstantDirection3.unit_direction = Vector2(4, -1).normalized()
	$ConstantDirection3.bullet_damage = 10
	$ConstantDirection4.unit_direction = Vector2(2, 3).normalized()
	$ConstantDirection4.bullet_damage = 20
	$ConstantDirection5.unit_direction = Vector2(-2, 3).normalized()
	$ConstantDirection5.bullet_damage = 5
