class_name Door
extends Node3D
## Door which probably starts locked.


@export var goes_to: String = "<Room>"
@export var logic_id: String = "<logic_id>"
@export_node_path("Portal") var portal_path

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var useable: Useable = $Hinge/Useable


func _ready() -> void:
	useable.logic_id = logic_id
	useable.title = "Door to %s" % goes_to

	ProgressManager.door_opened.connect(func (id):
		if id == name:
			open()
	)

	if portal_path:
		var portal: Portal = get_node(portal_path)
		portal.hide()


func open() -> void:
	# Swing that thang wide open.
	animation_player.play("open")

	if portal_path:
		var portal: Portal = get_node(portal_path)
		portal.show()
