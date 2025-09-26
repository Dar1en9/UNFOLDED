extends InteractableVisibleItem

@export var secret_code : String = ""
@export var is_the_servera := false

var is_solven : bool = false


func interact(interactor):
	if is_interactable:
		interactor.code_submitted.connect(_on_code_entered)
		interactor.get_code()

func _on_code_entered(text, interactor):
	print("code resived: ", text)
	if (text == secret_code):
		interactor.solved = is_the_servera
		is_solven = true
		print("code is correct!!")
		sound = null
		super.interact(interactor)
		interactor.stop_get_code()
		is_interactable = false
		
		interactor.solved = is_the_servera
		
	else:
		play_sound()
