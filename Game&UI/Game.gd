extends Node

var level_number = 1
var at_level_scene = false

var levels = {
	1: preload("res://Levels/Level1.tscn"),
	2: preload("res://Levels/Level2.tscn")
}
var Level_selection = preload("res://Game&UI/Level_selection.tscn")

var current_level = levels[1].instance()
var level_selection = Level_selection.instance()

func _ready():
	add_child(level_selection)

# Go to the next level from previous level
func next_level():
	remove_child(current_level)
	current_level.queue_free()
	level_number += 1
	current_level = levels[level_number].instance()
	add_child(current_level)

# Go to a selected level from level selection scene
func start_level(level_number):
	self.level_number = level_number
	remove_child(level_selection)
	level_selection.queue_free()
	current_level = levels[level_number].instance()
	add_child(current_level)
	at_level_scene = true

# Restart current level
func restart():
	remove_child(current_level)
	current_level.queue_free()
	current_level = levels[level_number].instance()
	add_child(current_level)

func _process(delta):
	if at_level_scene == true and Input.is_action_just_pressed("ui_restart"):
		restart()
