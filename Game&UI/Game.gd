extends Node

var level_number
var restartable = false

var levels = {
	1: preload("res://Levels/Level1.tscn"),
	2: preload("res://Levels/Level2.tscn"),
	3: preload("res://Levels/Level3.tscn")
}
var Level_selection = preload("res://Game&UI/Level_selection.tscn")
var Level_transition = preload("res://Game&UI/Level_transition.tscn")

var current_level   # type: instance of a level
var level_selection = Level_selection.instance()
var level_transition

func _ready():
	add_child(level_selection)

func _process(delta):
	if restartable == true and Input.is_action_just_pressed("ui_restart"):
		restart()


# show popup after level passed
func level_passed():
	level_transition = Level_transition.instance()
	add_child(level_transition)
	restartable = false

# Go to a selected level from level selection scene
func start_level(level_number):
	self.level_number = level_number
	remove_child(level_selection)
	current_level = levels[level_number].instance()
	add_child(current_level)
	restartable = true

# Restart current level
func restart():
	remove_child(current_level)
	current_level.queue_free()
	current_level = levels[level_number].instance()
	add_child(current_level)

# called when home button at each level is pressed
func go_home():
	remove_child(current_level)
	current_level.queue_free()
	add_child(level_selection)

# called when player died
func level_failed():
	# TO DO!!!
	pass



# The 3 functions below are only called
# when buttons in the level transition
# popup are pressed


# called by the replay button in level 
# transition popup
func replay_this_level_from_popup():
	remove_child(level_transition)
	restart()
	restartable = true

# called by the home button in level 
# transition popup
func go_home_from_popup():
	remove_child(level_transition)
	remove_child(current_level)
	current_level.queue_free()
	add_child(level_selection)

# called by the next level button in level transition popup
func next_level_from_popup():
	remove_child(level_transition)
	remove_child(current_level)
	current_level.queue_free()
	level_number += 1
	current_level = levels[level_number].instance()
	add_child(current_level)
	restartable = true
