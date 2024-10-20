@tool
class_name Curtain
extends ColorRect
# A very simple transitory cover.


signal drawn

@export var open_by_default := true :
	set (value):
		open_by_default = value
		_set_open_by_default(value)
@export var transition_time := 1.0

var is_active := false
var _active_tween: Tween


func _ready():
	_set_open_by_default(open_by_default)


# If a tween exists, we must cancel it.
func _cancel_active_tween():
	if _active_tween:
		_active_tween.kill()
		is_active = false


func _set_open_by_default(value: bool):
	modulate.a = 0.0 if value else 1.0
	visible = not value


func open(multiplier: float = 1.0):
	tween_to(0.0, multiplier)


func close(multiplier: float = 1.0):
	tween_to(1.0, multiplier)


func tween_to(value: float, multiplier: float):
	visible = true
	_cancel_active_tween()
	is_active = true

	_active_tween = create_tween()
	_active_tween.tween_property(self, "modulate:a", value, transition_time * multiplier)
	_active_tween.play()
	await _active_tween.finished

	if modulate.a == 0.0:
		visible = false

	_active_tween = null
	is_active = false
	drawn.emit()
