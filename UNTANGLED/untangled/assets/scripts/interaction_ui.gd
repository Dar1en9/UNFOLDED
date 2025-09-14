extends Control


@onready var panel: Panel = $Panel
@onready var label: Label = $Panel/Label

func start_dialogue(text):
	label.text = text
	visible = true;

func _input(event):
	if visible and event.is_action_pressed("ui_accept"):
		end_dialogue()

	
func end_dialogue():
	label.text = ""
	visible = false;
