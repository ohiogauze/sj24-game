class_name LogicItem
extends Object
## Holds data related to a Useable's logic.


signal changed

var id: String
var lines: PackedStringArray


func _init(data: Dictionary) -> void:
    id = data.id
    lines = PackedStringArray(data.lines)


func pack() -> Dictionary:
    return {
        "id": id,
        "lines": Array(lines),
    }


func set_lines(lines: Array):
    self.lines = lines
    print("CHANGED")
    changed.emit()