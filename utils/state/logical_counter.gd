class_name LogicalCounter
extends Object
## Counts the number of times the core logic of a logic script is hit.

## Internal counter.
var _count = 0
## ID of the logic attached.
var _id: String


func _init(id: String) -> void:
	_id = id


## Add one to the counter.
func add():
	_count += 1


## Count is equal to, or larger than, the provided value.
func at_least(value: int) -> bool:
	return _count >= value


## Count is equal to the provided value.
func equals(value: int) -> bool:
	return _count == value


func get_id() -> String:
	return _id