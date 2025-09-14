extends CharacterBody3D

# Camera settings
@export_group("Camera Settings")
@export var mouse_sensitivity: float = 0.002
@export var camera_smoothness: float = 10.0

# Movement settings
@export_group("Movement Settings")
@export var walk_speed: float = 5.0


@export var interaction_range = 3.0
@export var hold_position: Node3D

var held_object: RigidBody3D = null
var is_holding = false

#@onready var camera_pivot: Node3D = $CameraPivot
var camera: Camera3D
@onready var interaction_ray = $Camera3D/InteractionRay


# Rotation variables
var mouse_rotation: Vector2 = Vector2.ZERO

func _ready() -> void:
	camera = get_viewport().get_camera_3d()
	# Capture mouse on start
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event: InputEvent) -> void:
	# Handle mouse look
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		mouse_rotation = -event.relative * mouse_sensitivity
		
	# Toggle mouse capture with Escape key
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if event.is_action_pressed("interact"):
		if is_holding:
			release_object()
		else:
			try_interact()

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
	# Get movement input
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	
	# Calculate movement direction relative to camera orientation
	var direction: Vector3 = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Apply movement velocity
	if direction:
		velocity.x = direction.x * walk_speed
		velocity.z = direction.z * walk_speed
	else:
		# Gradually slow down when no input
		velocity.x = move_toward(velocity.x, 0, walk_speed)
		velocity.z = move_toward(velocity.z, 0, walk_speed)
	
	# Move the character
	move_and_slide()

func try_interact():
	if interaction_ray.is_colliding():
		var collider = interaction_ray.get_collider()

	#if collider is RigidBody3D and collider.has_method("pick_up"):
		#pick_up_object(collider)
	#elif collider.has_method("interact"):
		#collider.interact(self)

func pick_up_object(obj: RigidBody3D):
	if is_holding:
		return

	held_object = obj
	is_holding = true
	held_object.pick_up()

	# Disable physics while holding
	held_object.freeze = true
	held_object.collision_layer = 0
	held_object.collision_mask = 0

func release_object():
	if not is_holding or not held_object:
		return

	# Re-enable physics
	held_object.freeze = false
	held_object.collision_layer = 1
	held_object.collision_mask = 1

	# Apply a small forward velocity when releasing
	held_object.linear_velocity = camera.global_transform.basis.z * -2
	held_object.angular_velocity = Vector3.ZERO

	held_object.release()
	held_object = null
	is_holding = false
