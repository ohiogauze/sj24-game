extends State
## Show nothing in the HUD.


func enter():
	var hud: HUD = host
	hud.hide()
