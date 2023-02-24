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

const HealthBar = preload("res://Game&UI/HealthBar.tscn")


func _ready():
	add_child(level_selection)

func _process(delta):
	if restartable == true and Input.is_action_just_pressed("ui_restart"):
		restart()


func new_level_object(level_number):
	current_level = levels[level_number].instance()
	add_child(current_level)
	current_level.get_node("Indicator").rotation_degrees = rad2deg(Vector2.RIGHT.angle_to(current_level.astronaut_direction))
	for child in current_level.get_children():
		if (child.is_in_group("Character") and child.name != "Astronaut") or child.is_in_group("Enemies"):
			var health_bar = HealthBar.instance()
			health_bar.get_node("HealthBar").object = child
			health_bar.set_position(Vector2(-50, 20))
			health_bar.set_scale(Vector2(0.1, 0.1))
			child.add_child(health_bar)
		elif child.name == "Astronaut":
			var health_bar = HealthBar.instance()
			health_bar.get_node("HealthBar").object = child
			health_bar.set_position(Vector2(700, 30))
			health_bar.set_scale(Vector2(0.3, 0.3))
			current_level.add_child(health_bar)


# show popup after level passed
func level_passed():
	level_transition = Level_transition.instance()
	add_child(level_transition)
	restartable = false

# Go to a selected level from level selection scene
func start_level(level_number):
	self.level_number = level_number
	remove_child(level_selection)
	new_level_object(level_number)
	restartable = true

# Restart current level
func restart():
	remove_child(current_level)
	current_level.queue_free()
	new_level_object(level_number)

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
	new_level_object(level_number)
	restartable = true
