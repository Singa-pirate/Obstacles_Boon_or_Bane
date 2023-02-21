extends Node

var level_number = 1

var levels = {
	1: preload("res://Levels/Level1.tscn"),
	2: preload("res://Levels/Level2.tscn")
}

var current_level = levels[1].instance()

func _ready():
	add_child(current_level)

# Go to the level_number level
func next_level():
	remove_child(current_level)
	current_level.queue_free()
	level_number += 1
	current_level = levels[level_number].instance()
	add_child(current_level)

# Restart current level
func restart():
	remove_child(current_level)
	current_level.queue_free()
	current_level = levels[level_number].instance()
	add_child(current_level)
