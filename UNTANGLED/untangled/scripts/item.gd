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

@export var interaction_text = "Press E to pick up"

func _ready() -> void:
	if (texture_init):
		change_texture(texture_init)

func interact(interactor):
	if is_interactable:
		if (texture_interacted):
			change_texture(texture_interacted)

func pick_up() -> Texture:
	if (pick_up_texture):
		change_texture(picked_up_texture)
		return pick_up_texture
	visible = false
	return sprite_3d.texture
	

func release():
	print("Released ", item_name)
	
func change_texture(tex):
	sprite_3d.texture = tex
