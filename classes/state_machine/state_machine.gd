class_name StateMachine
extends Node
# An implementation of a finite state machine.


@export_node_path("Node") var host: NodePath

var _is_setup := false

var history := []
var state: Node # Un-typed in order to avoid cyclic dependency.


func _ready():
	state = get_child(0)

	if not state:
		push_error("State machine must have children")
		breakpoint

	call_deferred("_enter_state")


# Removes the state at the top of the stack and sets the one below.
func pop():
	if history.size() == 0:
		push_error("Cannot pop state in state machine '%s'" % name)
		breakpoint

	state.exit()
	state = get_node(history.pop_back())
	_enter_state()


# Adds a state to the top of the stack and sets it.
func push(new_state_name: String, setup_data = {}):
	history.append(state.get_path())
	state = get_node(new_state_name)
	state.setup(setup_data)
	_enter_state()


# Replaces the current state with the given one, disregarding history.
func swap(new_state_name: String):
	state.exit()
	state = get_node(new_state_name)
	_enter_state()


func _enter_state():
	_is_setup = true
	state.host = get_node(host)
	state.state_machine = self
	state.enter()


func _input(event):
	if state and _is_setup:
		state.on_input(event)


func _physics_process(delta):
	if state and _is_setup:
		state.on_physics_process(delta)


func _process(delta):
	if state and _is_setup:
		state.on_process(delta)


func _unhandled_input(event):
	if state and _is_setup:
		state.on_unhandled_input(event)


func _unhandled_key_input(event):
	if state and _is_setup:
		state.on_unhandled_key_input(event)
