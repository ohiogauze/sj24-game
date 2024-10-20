class_name House
extends Node
## The house where gameplay takes place.


## The shade over the screen.
@onready var curtain: Curtain = $Curtain
## The heads-up display.
@onready var hud: HUD = $HUD
## The player character.
@onready var player: Player = $Player


func _ready() -> void:
	player.controllers.useables.changed.connect(hud.show_collider)