class_name Player
extends CharacterBody3D
## Character controlled by the player.


## Handlers of various aspects of the PC.
@onready var controllers = {
	"camera": $Controllers/Camera,
	"movement": $Controllers/Movement,
	"useables": $Controllers/Useables
}
## State machine.
@onready var state_machine: StateMachine = $StateMachine