class_name State
extends Node
# Controls an encompassing slice of functionality.


var host: Node
var state_machine: StateMachine


func enter():
	pass # Virtual method


func exit():
	pass # Virtual method


func on_input(_event: InputEvent):
	pass # Virtual method


func on_physics_process(_delta: float):
	pass # Virtual method


func on_process(_delta: float):
	pass # Virtual method


func on_unhandled_input(_event: InputEvent):
	pass # Virtual method


func on_unhandled_key_input(_event: InputEvent):
	pass # Virtual method


func setup(_data: Dictionary):
	pass # Virtual method
