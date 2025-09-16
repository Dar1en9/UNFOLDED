extends InteractableItem

@export var dependent : Node3D
@export var move_dependent_for : Vector3

@export var move_duration : float

@export var activate_node : InteractableItem

var tween

func interact(interactor):
	if tween:
		tween.kill()
	tween = create_tween()
	print("momomomomve")
	tween.tween_property(dependent, "position", dependent.position + move_dependent_for, move_duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(queue_free)
	play_sound()
	tween.play()
	activate_node.is_interactable = true
