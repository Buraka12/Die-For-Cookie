extends Control

var level

var dict = {}
var events
func _ready() -> void:
	#level bilgisi çekme
	var dict : Dictionary = SaveLoad.load_game()
	if dict.has("current_level"):
		level = dict["current_level"]
	else:
		level = 1
		
	
	
	if level == 1:
		events = InputMap.action_get_events("Info")
		$InfoKey.text = '"' + events[0].as_text().trim_suffix(" (Physical)") + '"'
		
		events = InputMap.action_get_events("grab")
		$ControlKey.text = '"' + events[0].as_text().trim_suffix(" (Physical)") + '"'
			
		events = InputMap.action_get_events("grab")
		$GrabKey.text = '"' + events[0].as_text().trim_suffix(" (Physical)") + '"'
		
	if level == 4:
		events = InputMap.action_get_events("grab")
		$mirror.text = '"' + events[0].as_text().trim_suffix(" (Physical)") + '"'
		
		events = InputMap.action_get_events("LeftMouse")
		$left.text = '"' + events[0].as_text().trim_suffix(" (Physical)") + '"'
		
		events = InputMap.action_get_events("RightMouse")
		$right.text = '"' + events[0].as_text().trim_suffix(" (Physical)") + '"'
