class_name ConversationBrain
extends Object
## Reads through all the steps in a conversation and tells the starter what to do.

## When conversation has ended.
signal ended
## When a line of dialogue was spoken.
signal spoke(id: String, message: String)

var counter: LogicalCounter
var id: String
var steps: Array
## Technical indent level - control blocks add to this.
var current_indent: int
var current_step: int


func _init(useable: Useable):
	id = useable.logic_id
	steps = LogicStore.get_steps(id)

	if steps.size() == 0:
		steps = [{
			"type": "speech",
			"speaker": id,
			"message": "<NOT IMPLEMENTED>",
		}]

	counter = ProgressManager.get_logical_counter(id)
	current_indent = 0
	current_step = -1


## Processes future steps until an action takes place.
func next():
	current_step += 1

	if current_step >= steps.size():
		ended.emit()
		return

	var step = steps[current_step]

	match step.type:
		# Standard speech.
		"speech":
			spoke.emit(step.speaker, step.message)

		# If we ever flow into a block, then the previous block is over.
		"block", "exit":
			ended.emit()

		# Go to block by consuming all steps until we run out.
		"goto":
			var target = step.target

			for i in range(0, steps.size()):
				step = steps[i]
				if step.type == "block" and step.name == target:
					current_indent = 0
					current_step = i
					next()
					return

			# Bail out if
			printerr("Can't find block \"%s\"" % target)
			ended.emit()

		## Will only be hit if flowed on from a successful control block.
		"else":
			next_else_or_end()

		"end":
			current_indent -= 1
			next()

		"check", "has":
			current_indent += 1
			var dataset = ProgressManager.flags if step.type == "check" else ProgressManager.items
			var key = "flag" if step.type == "check" else "item"
			var fulfilled = dataset.has(step[key]) != step.is_negated
			if fulfilled:
				next()
				return

			next_else_or_end()

		"count":
			current_indent += 1
			var fulfilled = counter.at_least(step.value) if step.at_least else counter.equals(step.value)
			if fulfilled:
				next()
				return

			next_else_or_end()

		"loop":
			current_indent += 1
			var current_loop = ProgressManager.current_loop
			var fulfilled = current_loop >= step.value if step.at_least else current_loop == step.value
			if fulfilled:
				next()
				return

			next_else_or_end()

		## Player gives the item to someone / something else.
		"give":
			ProgressManager.items.remove(step.item)
			next()

		## Player takes the item.
		"take":
			ProgressManager.items.add(step.item)
			next()

		"set":
			var callable = ProgressManager.flags.remove\
				if step.is_negated\
				else ProgressManager.flags.add
			callable.call(step.flag)
			ProgressManager.trip_flag(step.flag)
			next()

		"accumulate":
			counter.add()
			next()

		"activate":
			ProgressManager.activate_useable(step.id)
			next()

		"open":
			ProgressManager.open_door(step.door)
			next()

func next_else_or_end():
	while current_step < steps.size():
		current_step += 1
		var step = steps[current_step]

		match step.type:
			"else", "end":
				current_indent -= 1 if step.type == "end" else 0
				next()
				return

	ended.emit()
