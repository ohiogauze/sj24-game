class_name Useable
extends CollisionObject3D
# Area which can be interacted with by a player.


signal used

@export var title: String = "<title>"


func _ready():
	# Put UseableAreas on their own special plane of existence.
	collision_layer = 256
	collision_mask = 256


func set_enabled(value: bool):
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = not value


func use():
	used.emit()
