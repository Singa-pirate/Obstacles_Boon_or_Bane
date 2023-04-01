extends Node

const MAX_CHAPTER_NUMBER = 3
const MAX_LEVEL_NUMBER = 5

var chapter_number
var level_number
var current_level
var restartable = false

const Level_selection_scenes = {
	1: preload("res://Game&UI/Chapter_selection_scenes/Chapter1.tscn"),
	2: preload("res://Game&UI/Chapter_selection_scenes/Chapter2.tscn"),
	3: preload("res://Game&UI/Chapter_selection_scenes/Chapter3.tscn")
}

const levels = {
	1: chapter1_levels,
	2: chapter2_levels,
	3: chapter3_levels
}

const chapter1_levels = {
	1: preload("res://Levels/Chapter1/C1Level1.tscn"),
	2: preload("res://Levels/Chapter1/C1Level2.tscn"),
	3: preload("res://Levels/Chapter1/C1Level3.tscn"),
	4: preload("res://Levels/Chapter1/C1Level4.tscn"),
	5: preload("res://Levels/Chapter1/C1Level5.tscn"),
}

const chapter2_levels = {
	1: preload("res://Levels/Chapter2/C2Level1.tscn"),
	2: preload("res://Levels/Chapter2/C2Level2.tscn"),
	3: preload("res://Levels/Chapter2/C2Level3.tscn"),
	4: preload("res://Levels/Chapter2/C2Level4.tscn")
}

const chapter3_levels = {
	1: null
}

const Level_transition = preload("res://Game&UI/Level_transition.tscn")
const Level_failed = preload("res://Game&UI/Level_failed.tscn")

var level_selection
var level_transition = Level_transition.instantiate()
var level_failed_scene = Level_failed.instantiate()

const HealthBar = preload("res://Game&UI/HealthBar.tscn")


func _ready():
	chapter_number = 1
	level_selection = Level_selection_scenes[chapter_number].instantiate()
	add_child(level_selection)

func _process(delta):
	if restartable == true and Input.is_action_just_pressed("ui_restart"):
		restart()


func new_level_object(level_number):
	current_level = levels[chapter_number][level_number].instantiate()
	add_child(current_level)
	current_level.get_node("Indicator").rotation_degrees = rad_to_deg(Vector2.RIGHT.angle_to(current_level.astronaut_direction))
	for child in current_level.get_children():
		if (child.is_in_group("Character") and child.name != "Astronaut") or child.is_in_group("Enemies"):
			var health_bar = HealthBar.instantiate()
			health_bar.get_node("HealthBar").object = child
			health_bar.set_position(Vector2(-50, 20))
			health_bar.set_scale(Vector2(0.1, 0.1))
			child.add_child(health_bar)
		if child.is_in_group("EnemyPath"):
			var enemy = child.get_child(0).get_child(0)
			var health_bar = HealthBar.instantiate()
			health_bar.get_node("HealthBar").object = enemy
			health_bar.set_position(Vector2(-50, 20))
			health_bar.set_scale(Vector2(0.1, 0.1))
			enemy.add_child(health_bar)
		elif child.name == "Astronaut":
			var health_bar = HealthBar.instantiate()
			health_bar.get_node("HealthBar").object = child
			health_bar.set_position(Vector2(700, 30))
			health_bar.set_scale(Vector2(0.3, 0.3))
			current_level.add_child(health_bar)


# show popup after level passed
func level_passed():
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
	add_child(level_failed_scene)
	restartable = false

# called when previous chapter button is pressed
func go_prev_chapter():
	if chapter_number > 1:
		remove_child(level_selection)
		level_selection.queue_free()
		chapter_number -= 1
		level_selection = Level_selection_scenes[chapter_number].instantiate()
		add_child(level_selection)

# called when next chapter button is pressed
func go_next_chapter():
	if chapter_number < MAX_CHAPTER_NUMBER:
		remove_child(level_selection)
		level_selection.queue_free()
		chapter_number += 1
		level_selection = Level_selection_scenes[chapter_number].instantiate()
		add_child(level_selection)


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

# called by the next level button in 
# level transition popup
func next_level_from_popup():
	remove_child(level_transition)
	remove_child(current_level)
	current_level.queue_free()
	level_number += 1
	new_level_object(level_number)
	restartable = true
