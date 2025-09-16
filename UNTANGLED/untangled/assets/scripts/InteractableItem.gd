extends StaticBody3D

class_name InteractableItem
@export var item_name = ""

@export var is_interactable = true
@export var is_pickble = false
@export var interact_requirement : String = "none" #id for an item that is requaerd for interaction
@export var sound : AudioStreamPlayer3D

@export var interaction_text = ""

const TRANSP = preload("res://assets/transp.png")

func interact(interactor):
	print("this should not be called")

func play_sound():
	if sound:
		sound.play()
