extends InteractableItem
class_name InteractableVisibleItem

@onready var sprite_3d: Sprite3D = $Sprite3D
@export var texture_init: Texture
@export var texture_interacted: Texture
@export var pick_up_texture : Texture = null
@export var picked_up_texture : Texture = null

func _ready() -> void:
	if (texture_init):
		change_texture(texture_init)
	#else:
		#change_texture(TRANSP)

func interact(interactor):
	if interact_requirement == "none" || interact_requirement == interactor.holding_name:
		
		if is_interactable:
			if (texture_interacted):
				change_texture(texture_interacted)
				play_sound()
			else:
				sprite_3d.texture = null
		
		if is_pickble:
			interactor.pick_up_object(self)
			play_sound()

func pick_up() -> Texture:
	if (pick_up_texture):
		change_texture(picked_up_texture)
		is_pickble = false
		return pick_up_texture
	visible = false
	is_interactable = false
	return sprite_3d.texture
	

func release():
	print("Released ", item_name)
	
func change_texture(tex):
	sprite_3d.texture = tex
