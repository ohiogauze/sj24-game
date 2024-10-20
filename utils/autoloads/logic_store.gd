extends Node
## Loads and holds all compiled logic.


var logic_list: Array = []


func _ready() -> void:
	var json: JSON = load("res://data/logic.json")
	logic_list = json.data


func get_steps(id: String) -> Array:
	for item in logic_list:
		if item.id == id:
			return CrabCompiler.build("\n".join(item.lines))

	return []