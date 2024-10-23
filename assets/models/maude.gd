@tool
extends Node3D

@onready var model: Node3D = $Maudel

func _process(_delta: float) -> void:
	if not model:
		return

	model.position.y = (1 + sin(Time.get_ticks_msec() *.002)) * .01