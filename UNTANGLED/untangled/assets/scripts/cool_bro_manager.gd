extends Node

var is_objective_met := false
var current_scene : int = 1

func change_scene():
	match current_scene:
		1:
			get_tree().change_scene_to_file("res://scenes/world_2.tscn")
			current_scene = 2
		2:
			get_tree().change_scene_to_file("res://scenes/world.tscn")
			is_objective_met = true
			current_scene = 3
