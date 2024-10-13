class_name Player
extends CharacterBody3D
## Character controlled by the player.


@onready var controllers = {
	"camera": $Controllers/Camera,
	"movement": $Controllers/Movement,
	"useables": $Controllers/Useables
}
