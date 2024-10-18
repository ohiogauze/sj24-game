@tool
class_name CrabCompiler
extends Object
## Converts CrabScript lines to an array of objects.


## Converts lines from input into dicts.
static func build(text: String, listener = null) -> Array:
	# Split up the input and clean it up.
	var array := Array(text.split("\n"))\
		.map(func (item: String): return item.strip_edges())\
		.filter(func (item: String): return item.length() > 0)

	return array.map(func (line):
		var segments = Array(line.split(" "))
		var first: String = segments.pop_front()

		# Identify a conversation block.
		if first.begins_with("::"):
			if segments.size() > 0:
				return CrabCompiler._build_error("A conversation block must have 0 arguments.")
			return CrabCompiler._build_block(first)
		# Identify explicit speech. eg. "Jojo: Hi"
		elif first.ends_with(":"):
			if first == ":":
				if not listener:
					var error_message := "Can't use ':' shorthand with no default listener."
					return CrabCompiler._build_error(error_message)
				return CrabCompiler._build_speech(listener, segments)

			var speaker := first.substr(0, first.length() - 1)
			return CrabCompiler._build_speech(speaker, segments)

		# Identify command line. eg. ":has key"
		elif first.begins_with(":"):
			var is_negated = first.begins_with(":!")
			var command = first.substr(2 if is_negated else 1)
			return CrabCompiler._build_command(command, segments, is_negated)

		# Identify implicit player speech line. eg. "Hello"
		else:
			segments.push_front(first)
			return CrabCompiler._build_speech("Player", segments)
	)


## Build structued block data.
static func _build_block(text: String) -> Dictionary:
	if text.length() == 2:
		return CrabCompiler._build_error("Please name your conversation block.")
	return {
		"type": "block",
		"name": text.substr(2),
	}


## Build structured command data.
static func _build_command(command: String, args: Array, is_negated: bool) -> Dictionary:
	## Returns an error, if one exists based on inputs.
	var get_error = func(num_args: int, can_negate: bool, default: Callable) -> Dictionary:
		if args.size() != num_args:
			return CrabCompiler._build_error("':%s' expects %s argument(s)." % [command, num_args])

		if is_negated and not can_negate:
			return CrabCompiler._build_error("':%s' cannot be negated." % command)

		return default.call()


	match command:
		## Check statements

		# Whether or not user has an item. One arg expected.
		# eg. :has key
		"has":
			return get_error.call(1, true, func ():
				return {
					"type": "has",
					"item": args[0],
					"is_negated": is_negated,
				})

		# Contrary condition to previous control statement.
		"else":
			return get_error.call(0, false, func():
				return {
					"type": "else",
				})

		# Checks a flag within the current hour, running following steps if true.
		# Negations runs steps if false.
		"check":
			return get_error.call(1, true, func():
				return {
					"type": "check",
					"flag": args[0],
					"is_negated": is_negated,
				})
			
		# Determines based on number of times dialogue hit.
		# Appending a + means "at least".
		"count":
			var number = args[0].substr(0, args[0].length() - 1) if args[0].ends_with("+") else args[0]

			if not number.is_valid_int():
				return CrabCompiler._build_error("\"%s\" is not a valid input." % args[0])

			return get_error.call(1, false, func ():
				return {
					"type": "count",
					"value": int(number),
					"at_least": args[0].ends_with("+")
				})

		# Sets a flag within the current hour.
		# Negation determines whether true or false.
		"set":
			return get_error.call(1, true, func():
				return {
					"type": "set",
					"flag": args[0],
					"is_negated": is_negated,
				})

		## Action statements

		# Gives the user an item.
		# eg. :give key
		"give":
			return get_error.call(1, false, func():
				return {
					"type": "give",
					"item": args[0],
				})

		# Takes an item from the user
		# eg. :take key
		"take":
			return get_error.call(1, false, func():
				return {
					"type": "take",
					"item": args[0],
				})

		# Adds one to the conversation counter.
		"accumulate":
			return get_error.call(0, false, func():
				return {
					"type": "accumulate"
				})

		## Other statements

		# Takes us to another conversation.
		"goto":
			return get_error.call(1, false, func ():
				return {
					"type": "goto",
					"target": args[0],
				})

		# Exits the conversation immediately.
		"exit":
			return get_error.call(0, false, func ():
				return {
					"type": "exit",
				})

		# End of control block (eg. has, etc).
		"end":
			return get_error.call(0, false, func():
				return {
					"type": "end",
				})

	# Any other command is unexpected, therefore an error.
	return CrabCompiler._build_error("Unknown command '%s'" % command)


## Build structured speech data.
static func _build_speech(speaker: String, segments: Array) -> Dictionary:
	var message := " ".join(segments)
	return {
		"type": "speech",
		"speaker": speaker,
		"message": message,
	}


## Build structured error data.
static func _build_error(message: String) -> Dictionary:
	return {
		"type": "error",
		"message": message,
	}
