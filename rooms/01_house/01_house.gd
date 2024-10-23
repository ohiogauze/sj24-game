class_name House
extends Node
## The house where gameplay takes place.


## Background music.
@onready var bgm: AudioStreamPlayer = $BGM
## Displays conversation.
@onready var conversation_display: Node = $ConversationDisplay
## The shade over the screen.
@onready var curtain: Curtain = $Curtain
## The heads-up display.
@onready var hud: HUD = $HUD
## The player character.
@onready var player: Player = $Player
## State machine.
@onready var state_machine: StateMachine = $StateMachine


func _ready() -> void:
	player.controllers.useables.changed.connect(hud.show_collider)
	ProgressManager.useable_used.connect(start_conversation)
	ProgressManager.loop_ended.connect(fail)
	$FailureModels.hide()
	$Red.hide()


func fail() -> void:
	state_machine.swap("Failure")


func start_conversation(useable: Useable) -> void:
	state_machine.push("Conversation", {
		"conversation_display": conversation_display,
		"useable": useable,
	})
