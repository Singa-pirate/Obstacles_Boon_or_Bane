extends CharacterBody2D


var MAX_HEALTH = 200
var health = MAX_HEALTH
var health_constant = 1

var is_invincible = false


func _process(delta):
	if health <= 0:
		die()


func die():
	queue_free()


func take_damage(damage):
	if not is_invincible:
		health -= health_constant * damage
		is_invincible = true
		$InvincibilityTimer.start()


func wormhole_disappear():
	$AnimatedSprite2D.modulate.a = 0
	set_process_mode(4)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)


func wormhole_reappear():
	$AnimatedSprite2D.modulate.a = 1
	set_process_mode(0)
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)


func _on_invincibility_timer_timeout():
	is_invincible = false
