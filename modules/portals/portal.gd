@tool
class_name Portal
extends Area3D
## Counts moves when player passes through.


# @export var useable: Useable
@export var logic_id: String

const MIN_DISTANCE = 1.0
const MAX_DISTANCE = 2.5

const UseableScript = preload("res://classes/interactive/useable.gd")

@onready var beep: AudioStreamPlayer3D = AudioStreamPlayer3D.new()


func _ready() -> void:
	beep.stream = load("res://assets/sfx/move_spend.wav")
	add_child(beep)

	body_entered.connect(func (body):
		if not visible:
			return

		if body is Player:
			if logic_id != "":
				var useable = Area3D.new()
				useable.set_script(UseableScript)
				useable.logic_id = logic_id
				ProgressManager.report_usage(useable)
				return

			beep.pitch_scale = 0.96 + 0.08 * randf()
			beep.play()
			ProgressManager.consume_move()
	)


func _process(_delta: float) -> void:
	var camera := EditorInterface.get_editor_viewport_3d(0).get_camera_3d() if Engine.is_editor_hint() else get_viewport().get_camera_3d() 
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
