class_name TimeFile
extends Object
## Holds data related to a time file.


var day: int
var hour: int
var filename: String


func _init(filename: String) -> void:
	self.filename = filename

	var elements := filename.replace(".time.json", "").split("@")
	self.day = int(elements[0].right(-3))
	self.hour = int(elements[1].right(-4))

	assert(hour >= 0 and hour <= 23, "Hour is outside accepted range (value: %s)" % hour)


func _get_formatted_time(i: int) -> String:
	var hour = i - 12 if i > 12 else i
	return "%s:00 %s" % [hour, "PM" if i >= 12 else "AM"]


func get_end() -> String:
	return _get_formatted_time(hour + 1)


func get_start() -> String:
	return _get_formatted_time(hour)


func get_filename() -> String:
	return "res://data/times/day%s@hour%s.time.json" % [day, hour]


func read() -> Dictionary:
	var file = FileAccess.open(get_filename(), FileAccess.READ)
	return JSON.parse_string(file.get_as_text())


func write(dict: Dictionary):
	var file = FileAccess.open(get_filename(), FileAccess.WRITE)
	file.store_string(JSON.stringify(dict, "\t"))
	file.close()


func get_conversation_lines(speaker: String) -> Array:
	var data = read()

	for conversation in data.conversations:
		if conversation.speaker == speaker:
			return conversation.lines

	return []


func set_character_placement(values: Dictionary):
	var data = read()
	var characters: Array = data.characters.filter(func (char): return char.id != values.id)
	characters.append({
		"id": values.id,
		"type": "in_world",
		"spawn": "%s:%s" % [values.room, values.spawn]
	})
	characters.sort_custom(func (a, b): return a.id < b.id)
	data.merge({ "characters": characters }, true)
	write(data)
	return characters


func set_conversation(speaker: String, lines: Array):
	var data = read()
	var conversations: Array = data.conversations.filter(func (conv): return conv.speaker != speaker)
	if lines.size() and "\n".join(lines) != "":
		conversations.append({
			"speaker": speaker,
			"lines": lines,
		})
	conversations.sort_custom(func (a, b): return a.speaker < b.speaker)
	data.merge({ "conversations": conversations }, true)
	write(data)
	return conversations
