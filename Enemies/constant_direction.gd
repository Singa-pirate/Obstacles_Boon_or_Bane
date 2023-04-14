extends CharacterBody2D


var MAX_HEALTH = 20 # to be reset
var health = MAX_HEALTH

var damage = 5

var unit_direction = Vector2.RIGHT # to be reset
const bullet_position_offset = Vector2.ZERO

var Bullet = preload("res://Enemies/ConstantDirectionBullet.tscn") # to be reset
var bullet_damage = 5


func _ready():
	$AnimationPlayer.play("animation")


func _physics_process(delta):
	if health <= 0:
		die()

func reset_bullet_rate(duration):
	$BulletTimer.wait_time = duration
	

func take_damage(damage):
	health -= damage
	# play animation

func die():
	queue_free()

func _on_BulletTimer_timeout():
	var bullet = Bullet.instantiate()
	bullet.unit_direction = unit_direction
	bullet.position = position + bullet_position_offset
	bullet.damage = bullet_damage
	get_parent().add_child(bullet)
