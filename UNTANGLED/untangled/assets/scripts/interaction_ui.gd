extends Control


@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

var is_change : bool = false

func start_dialogue(text : String, solved : bool):
	label.text = text
	visible = true;
	is_change = solved

func _input(event):
	if visible and event.is_action_pressed("ui_accept") || event.is_action_pressed("move_left") || event.is_action_pressed("move_right") || event.is_action_pressed("move_forward") || event.is_action_pressed("move_back"):
		end_dialogue()

	
func end_dialogue():
	label.text = ""
	visible = false;
	
	if (is_change):
		CoolBroManager.change_scene()
