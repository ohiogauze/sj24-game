extends State
## When gameplay is paused.


const PauseMenu = preload("res://modules/pause_menu/pause_menu.tscn")

var bgm_state_cache: bool
var menu: Control
var mouse_cache: Input.MouseMode


func enter():
	var house: House = host
	house.hud.state_machine.push("Blank")
	house.player.state_machine.push("Frozen")

	bgm_state_cache = house.bgm.stream_paused
	house.bgm.stream_paused = true

	mouse_cache = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	menu = PauseMenu.instantiate()
	house.add_child(menu)
	menu.closed.connect(func ():
		state_machine.pop()
		menu.queue_free()
	)


func exit():
	var house: House = host
	house.hud.state_machine.pop()
	house.player.state_machine.pop()

	house.bgm.stream_paused = bgm_state_cache
	Input.mouse_mode = mouse_cache