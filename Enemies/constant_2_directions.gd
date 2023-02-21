extends KinematicBody2D


const MAX_HEALTH = 20 # to be reset
var health = MAX_HEALTH

var unit_direction = Vector2.RIGHT # to be reset
var unit_direction2 = Vector2.LEFT # to be reset
const bullet_position_offset = Vector2.ZERO
const bullet_position_offset2 = Vector2.ZERO

var Bullet = preload("res://Enemies/ConstantDirectionBullet.tscn") # to be reset
var Bullet2 = preload("res://Enemies/ConstantDirectionBullet.tscn")


func reset_bullet_rate(duration):
	$BulletTimer.wait_time = duration


func take_damage(damage):
	health -= damage
	# play animation


func _on_BulletTimer_timeout():
	var bullet = Bullet.instance()
	bullet.unit_direction = unit_direction
	bullet.position = position + bullet_position_offset
	get_parent().add_child(bullet)
	
	var bullet2 = Bullet2.instance()
	bullet2.unit_direction = unit_direction2
	bullet2.position = position + bullet_position_offset2
	get_parent().add_child(bullet2)