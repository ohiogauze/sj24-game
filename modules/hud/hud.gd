class_name HUD
extends Control
## Heads-up display for gameplay.

## State machine.
@onready var state_machine: StateMachine = $StateMachine
## The whole reticle.
@onready var reticle: Control = $MarginContainer/Control/Reticle
## Just the active part of the reticle.
@onready var active_reticle: ColorRect = $MarginContainer/Control/Reticle/Active
## Info regarding the highlighted collider.
@onready var collider_info: Control = $MarginContainer/Control/ColliderInfo
## The loop counter.
@onready var loop_counter: Control = $MarginContainer/Control/LoopCounter
## The move counter.
@onready var move_counter: Control = $MarginContainer/Control/MoveCounter


func _ready() -> void:
	active_reticle.hide()
	collider_info.hide()

	ProgressManager.moves_left_changed.connect(set_moves_left)


## Sets the move counter.
func set_moves_left(moves_left: int) -> void:
	move_counter.get_node("Count").text = str(moves_left)


## Shows info regarding the highlighted collider (if exists).
func show_collider(useable: Useable) -> void:
	if not useable:
		active_reticle.hide()
		collider_info.hide()
		return

	active_reticle.show()
	collider_info.get_node("Title").text = useable.title
	collider_info.show()