extends Node
## Tracks progress of the game across loops.

## Data structure enabling having only one of each item.
class Set:
	var data = {}

	func add(item: String) -> void:
		data[item] = null

	func remove(item: String) -> void:
		data.erase(item)

	func has(item: String) -> bool:
		return data.has(item)

## How many moves the player has per loop.
const MOVES_PER_LOOP: int = 28

## All logical counters derived from the Logic tab.
var _logical_counters: Array[LogicalCounter] = []
## The loop we're currently in. We start outside of a loop.
var current_loop := 0
## All flags.
var flags := Set.new()
## Player's inventory.
var items := Set.new()
## Moves left in this loop.
var moves_left := MOVES_PER_LOOP

## Alerts that a door should be opened.
signal door_opened(door: String)
## Alerts that the loop end conditions have been met.
signal loop_ended
## Alerts that the number of moves left has changed.
signal moves_left_changed(value: int)
## Alerts that a Useable should be activated.
signal useable_activated(id: String)
## Alerts that a Useable has been used.
signal useable_used(useable: Useable)


### LOOP FUNCTIONS

## Uses a move.
func consume_move():
	moves_left = max(0, moves_left - 1)
	moves_left_changed.emit(moves_left)

	# End the loop when there are no moves left.
	if moves_left <= 0:
		end_loop()


## End the loop whenever.
func end_loop():
	loop_ended.emit()

	# For now, just reset all and restart room.
	flags.data = {}
	items.data = {}
	get_tree().reload_current_scene()

## Start a new loop.
func start_loop():
	current_loop += 1
	moves_left = MOVES_PER_LOOP


### LOGIC FUNCTIONS

## Signals that Useables should be activated.
func activate_useable(id: String):
	useable_activated.emit(id)

## Returns the logical counter for the ID. Creates if doesn't exist.
func get_logical_counter(id: String) -> LogicalCounter:
	# Try to find the counter and return it.
	for counter in _logical_counters:
		if id == counter.get_id():
			return counter

	# If we can't find the counter, create one.
	var counter = LogicalCounter.new(id)
	_logical_counters.append(counter)
	return counter


## Signals that a Door should be opened.
func open_door(door: String) -> void:
	door_opened.emit(door)


## Bubbles up a Useable usage.
func report_usage(useable: Useable) -> void:
	useable_used.emit(useable)