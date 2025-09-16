extends InteractableVisibleItem

@export var secret_code : String = ""

var is_solven : bool = false


func interact(interactor):
	if is_interactable:
		interactor.code_submitted.connect(_on_code_entered)
		interactor.get_code()

func _on_code_entered(text, interactor):
	print("code resived: ", text)
	if (text == secret_code):
		is_solven = true
		print("code is correct!!")
		super.interact(interactor)
		interactor.stop_get_code()
		is_interactable = false
	else:
		play_sound()
