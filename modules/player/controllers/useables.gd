extends Node
# Controls detection and use of Useables.


signal changed(collider: Useable)

@export_node_path("RayCast3D") var general_raycast_path
@onready var general_raycast: RayCast3D = get_node(general_raycast_path)
@export_node_path("CharacterBody3D") var body_path
@onready var body: CharacterBody3D = get_node(body_path)

var current: Useable = null
var paused := false


func _process(_delta):
	if paused:
		return

	_detect()
	if Input.is_action_just_pressed("use"):
		_use()


# Process current detection from the RayCast.
func _detect():
	if paused:
		return

	var collider = general_raycast.get_collider()
	var force_update := false

	# Nullify collider if collision is not of Useable.
	if collider and not (collider is Useable):
		collider = null

	# Nullify collider if talkable and not on ground.
	#if collider and collider is UseableTalkable and not body.is_on_floor():
		#collider = null

	# Force an update if the current object was deleted.
	if current is Object and not is_instance_valid(current):
		current = null
		force_update = true

	if collider != current or force_update:
		current = collider if is_instance_valid(collider) else null
		changed.emit(current)


# Actively make use of a UseableArea.
func _use():
	if paused:
		return

	# Prevent usage of recently deleted nodes.
	if current and is_instance_valid(current):
		print("USED")
		# Avoid loss of reference during timeout.
		var node = current

		node.use()

		# Hide prompt and stop movement if talkable.
		#if node is UseableTalkable:
			#body.velocity = Vector3.ZERO
			#node = null
			#changed.emit(null)
