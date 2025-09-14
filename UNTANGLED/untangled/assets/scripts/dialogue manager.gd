extends Control

@export var intro_dialogue : Array[DialRes]
var queue : Array[DialRes]
var curr_replic : Array[String]

@onready var speacers_colors = [
	preload("res://assets/styleboxes/girl_center_style_box_flat.tres"),
	preload("res://assets/styleboxes/girl_left_style_box_flat.tres"),
	preload("res://assets/styleboxes/girl_right_style_box_flat.tres")
]

@onready var speacers = [
	$"../../ghost",
	$"../../ghost2",
	$"../../ghost3"
]

@onready var background: ColorRect = $Panel/Background

@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

func _ready() -> void:
	start_dialogue(intro_dialogue)

func start_dialogue(lines : Array[DialRes]):
	label.text = ""
	visible = true;
	queue = lines
	
	next_line()

func _input(event):
	if visible and event.is_action_pressed("ui_accept"):
		next_line()

func next_replic():
	if len(queue) == 0:
		end_dialogue()
		return
	
	var next_rep : DialRes = queue.pop_front()
	set_panel_colors(speacers_colors[next_rep.speaker_ind])
	speacers[next_rep.speaker_ind].squish_animation()
	curr_replic = next_rep.dialogue_lines
	next_line()

func next_line():
	if len(curr_replic) == 0:
		next_replic()
		return
		
	label.text = curr_replic.pop_front()
	
func end_dialogue():
	label.text = ""
	visible = false;
	


func set_panel_colors(colors):
	
	panel.add_theme_stylebox_override("panel", colors)
	#panel.border_color = colors[0]

	#panel.set_bg_color(colors[0])
	#panel.set_border_color(colors[1])
