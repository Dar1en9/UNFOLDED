extends StaticBody3D

class_name InteractableItem
@export var item_name = ""

@export var is_interactable = false
@export var is_pickble = false
@export var interact_requirement : String = "none" #id for an item that is requaerd for interaction

@onready var sprite_3d: Sprite3D = $Sprite3D
@export var texture_init: Texture
@export var texture_interacted: Texture
@export var pick_up_texture : Texture = null
@export var picked_up_texture : Texture = null

@export var change_dependent : bool = false
@export var dependent : Node3D
@export var move_dependent_for : Vector3

@export var interaction_text = ""

@export var secret_code : String = ""

const TRANSP = preload("res://assets/transp.png")

func _ready() -> void:
	if (texture_init):
		change_texture(texture_init)
	else:
		change_texture(TRANSP)

func interact(interactor):
	if is_interactable:
		if change_dependent:
			dependent.position += move_dependent_for
			is_interactable = false
			queue_free()
		
		if (texture_interacted):
			change_texture(texture_interacted)

func pick_up() -> Texture:
	if (pick_up_texture):
		change_texture(picked_up_texture)
		is_interactable = false
		return pick_up_texture
	visible = false
	is_interactable = false
	return sprite_3d.texture
	

func release():
	print("Released ", item_name)
	
func change_texture(tex):
	sprite_3d.texture = tex
