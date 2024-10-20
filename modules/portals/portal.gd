class_name Portal
extends Area3D
## Counts moves when player passes through.


const MIN_DISTANCE = 1.0
const MAX_DISTANCE = 2.5


func _ready() -> void:
	body_entered.connect(func (body):
		if body is Player:
			ProgressManager.consume_move()
	)


func _process(_delta: float) -> void:
	var camera := get_viewport().get_camera_3d()
	var camera_pos = Vector2(camera.global_position.x, camera.global_position.z)
	var pos = Vector2(global_position.x, global_position.z)
	var distance = camera_pos.distance_to(pos)

	if distance > MAX_DISTANCE:
		set_opacity(0.0)
	elif distance < MIN_DISTANCE:
		set_opacity(1.0)
	else:
		set_opacity(1.0 - (distance - MIN_DISTANCE) / (MAX_DISTANCE - MIN_DISTANCE))


func set_opacity(opacity: float):
	for child in get_children():
		if child is MeshInstance3D:
			child.get_active_material(0).albedo_color.a = opacity