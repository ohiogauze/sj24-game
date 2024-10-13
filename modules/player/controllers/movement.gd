extends Node
# A movement controller for CharacterBody3D.


const GRAVITY = 33.33
const JUMP_SPEED = 6.66

@export var speed := 4.2
@export_node_path("CharacterBody3D") var path
@onready var body: CharacterBody3D = get_node(path)

var accepting_input := true
var paused := false


func _physics_process(delta):
	if paused:
		return

	# Figure out which direction the player wants us to go in.
	var intent = Input.get_vector(
		"move_left", "move_right",
		"move_backward", "move_forward"
	) if accepting_input else Vector2.ZERO

	# Correct angle based on active camera rotation.
	var camera = get_viewport().get_camera_3d()
	intent = intent.rotated(camera.rotation.y)

	# Apply planar movement.
	var weight = .2 if body.is_on_floor() else .02
	body.velocity.x = lerp(body.velocity.x, intent.x * speed, weight)
	body.velocity.z = lerp(body.velocity.z, intent.y * -speed, weight)

	# Apply gravity.
	body.velocity.y -= GRAVITY * delta

	# Activate jump if possible.
	if accepting_input and Input.is_action_just_pressed("jump") and body.is_on_floor():
		body.velocity.y = JUMP_SPEED

	body.move_and_slide()
