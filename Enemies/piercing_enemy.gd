extends CharacterBody2D


var damage = 4

const Bullet = preload("res://Enemies/PiercingBullet.tscn")
var bullet_damage = 7

const MAX_HEALTH = 80
var health = MAX_HEALTH


func start():
	$BulletTimer.start()


func take_damage(damage):
	health -= damage


func _process(delta):
	if health < 0:
		die()


func die():
	queue_free()


# to be called when the level requires a different direction
func change_gun_direction(gun_direction):
	var angle = Vector2.RIGHT.angle_to(gun_direction)
	$Gun.rotation_degrees = rad_to_deg(angle)
	if (angle > PI / 4) and (angle < 3 * PI / 2):
		pass # flip the sprite


func _on_bullet_timer_timeout():
	var bullet = Bullet.instantiate()
	bullet.damage = bullet_damage
	bullet.position = position
	var angle = deg_to_rad($Gun.rotation_degrees)
	bullet.direction = Vector2(cos(angle), sin(angle))
	get_parent().add_child(bullet)
