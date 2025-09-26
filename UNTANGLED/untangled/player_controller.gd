extends CharacterBody3D

# Camera settings
@export_group("Camera Settings")
@export var mouse_sensitivity: float = 0.02
@export var camera_smoothness: float = 10.0

# Movement settings
@export_group("Movement Settings")
@export var walk_speed: float = 5.0

@export var code_id = -1

@onready var hold_item: Sprite3D = $Camera3D/hold_item

var holding_name : String = "none"

#@onready var camera_pivot: Node3D = $CameraPivot
var camera: Camera3D
@onready var interaction_ray = $Camera3D/InteractionRay
@onready var control: Control = $"interaction ui/Control"

@onready var input_field: LineEdit = $"interaction ui/Control2/LineEdit"
@onready var interhint: Label = $"interaction ui/interhint"

signal code_submitted(String, Node)

var is_texxxxxt := false

var solved := false

var mouse_rotation: Vector2 = Vector2.ZERO

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	# Capture mouse on start
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	input_field.visible = false
	input_field.text_submitted.connect(_on_text_entered)

func _input(event: InputEvent) -> void:
	# Handle mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_rotation = -event.relative * mouse_sensitivity
		
	# Toggle mouse capture with Escape key
	if Input.is_action_just_pressed("ui_cancel"):
		if is_texxxxxt:
			stop_get_code()
		else:
			if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			else:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("interact"):
		try_interact()
	
	if event.is_action_pressed("hide_heand"):
		hide_heand()

func _process(delta: float) -> void:
	# Apply smooth camera rotation
	if mouse_rotation != Vector2.ZERO:
		# Horizontal rotation (Y-axis)
		rotation.y = lerp(rotation.y, rotation.y + mouse_rotation.x, camera_smoothness * delta)
		
		# Vertical rotation (X-axis)
		camera.rotation.x = lerp(camera.rotation.x, camera.rotation.x + mouse_rotation.y, camera_smoothness * delta)
		
		# Clamp vertical camera rotation to prevent over-rotation
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		
		# Reset mouse rotation for next frame
		mouse_rotation = Vector2.ZERO

func _physics_process(delta: float) -> void:
		
	if !is_texxxxxt:
		var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
		var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		if direction:
			velocity.x = direction.x * walk_speed
			velocity.z = direction.z * walk_speed
		else:
			velocity.x = move_toward(velocity.x, 0, walk_speed)
			velocity.z = move_toward(velocity.z, 0, walk_speed)
		
		move_and_slide()
	
	

func try_interact():
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()
		if collider.has_method("interact"):
			collider.interact(self)

func pick_up_object(obj):
	hold_item.visible = true
	hold_item.texture = obj.pick_up()
	holding_name = obj.item_name


func get_code():
	input_field.visible = true
	input_field.grab_focus()
	is_texxxxxt = true

func stop_get_code():
	input_field.visible = false
	input_field.text = ""
	input_field.release_focus()
	is_texxxxxt = false
	disconnect_all_from_signal(code_submitted)

func _on_text_entered(text):
	emit_signal("code_submitted", text, self)
	stop_get_code()

func hide_heand():
	hold_item.visible = !hold_item.visible

func disconnect_all_from_signal(sig: Signal) -> void:
	for connection in sig.get_connections():
		sig.disconnect(connection.callable)

func display_text(text : String):
	control.start_dialogue(text, solved)
