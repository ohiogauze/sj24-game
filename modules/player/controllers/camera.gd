extends Node
# A first-person controller for Camera.


@export_node_path("Camera3D") var camera_path
@onready var camera: Camera3D = get_node(camera_path)
@export_node_path("Player") var player_path
@onready var player: Player = get_node(player_path)

var paused := false


func _ready():
	if player.get_parent().get_parent() is SubViewport:
		return

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# TODO: Apply settings to camera initially.

	assert(camera.rotation_order == EULER_ORDER_YXZ, "Camera order must be YXZ")


func _input(event):
	if paused:
		return

	# Rotate camera based on mouse motion.
	if event is InputEventMouseMotion:
		# Determine intent based on mouse motion and tiny multiplier.
		process_motion(event.relative * -.01)


func _process(delta):
	if paused:
		return

	var velocity = clamp(player.velocity.length() / 2, 0, 2) * .0125
	var time = Time.get_ticks_msec() / 100.0
	camera.v_offset = sin(time) * velocity

	var gamepad_intent = Input.get_vector("view_left", "view_right", "view_up", "view_down") * -1

	if gamepad_intent.length() > 0:
		process_motion(gamepad_intent * delta * 5)


func process_motion(intent: Vector2):
	if paused:
		return

	# TODO: Move mouse_sensitivity into settings.
	var mouse_sensitivity = .5

	# Actually move camera based on intent and sensitivity.
	camera.rotation.x += intent.y * mouse_sensitivity
	camera.rotation.y += intent.x * mouse_sensitivity

	# Restrict vertical rotation.
	camera.rotation.x = clamp(camera.rotation.x, -PI / 2, PI / 2)
