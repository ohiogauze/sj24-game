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
## The demonic lady.
@onready var maude: Node3D = $Objects/Maude
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
	maude.hide()
	maude.position.y += 50

	ProgressManager.flag_tripped.connect(func (flag: String):
		match flag:
			"smoke_alarm_on":
				do_smoke_alarm()

			"has_knife":
				$StructureModel/knife.hide()

			"killed_her":
				bgm.stop()
				curtain.modulate.a = 1.0
				curtain.show()
				hud.state_machine.swap("Blank")
				player.state_machine.swap("Frozen")
				$Stab.play()
				await get_tree().create_timer(3.0).timeout
				get_tree().change_scene_to_file("res://modules/credits/credits.tscn")
	)


func fail() -> void:
	state_machine.swap("Failure")


func start_conversation(useable: Useable) -> void:
	state_machine.push("Conversation", {
		"conversation_display": conversation_display,
		"useable": useable,
	})


func do_smoke_alarm() -> void:
	maude.show()
	maude.position.y = 0
	$Alarm.play()