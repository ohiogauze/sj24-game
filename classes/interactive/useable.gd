class_name Useable
extends CollisionObject3D
# Area which can be interacted with by a player.


signal used

@export var title: String = "<title>"
@export var logic_id: String = "<logic_id>"

func _ready():
	# Put UseableAreas on their own special plane of existence.
	collision_layer = 256
	collision_mask = 256

	ProgressManager.useable_activated.connect(func (id: String):
		if id == logic_id:
			set_enabled(true)
	)


func set_enabled(value: bool):
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = not value


func use():
	ProgressManager.report_usage(self)
	used.emit()
	set_enabled(false)
