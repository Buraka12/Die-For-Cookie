extends Node

@export var music : float = 0.5
@export var sfx : float = 0.5
@export var current_level : int = 1
@export var unlocked_levels : int = 1
@export var window_mode : bool = false
@export var antialiasing : int = 0

var firs_time : bool = true

func _ready():
	# Kayıtlı oyun verilerini yükle
	load_game_state()
	# Process mode'u ayarla ki pause'da da çalışabilsin
	process_mode = Node.PROCESS_MODE_ALWAYS

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game_state()
		get_tree().quit()
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		# Uygulama focus kaybettiğinde kaydet
		save_game_state()

func load_game_state():
	var save_data = SaveLoad.load_game()
	if save_data.has("music"):
		music = save_data["music"]
	if save_data.has("sfx"):
		sfx = save_data["sfx"]
	if save_data.has("current_level"):
		current_level = save_data["current_level"]
	if save_data.has("unlocked_levels"):
		unlocked_levels = save_data["unlocked_levels"]
	if save_data.has("window_mode"):
		window_mode = save_data["window_mode"]
		_apply_window_mode()
	if save_data.has("antialiasing"):
		antialiasing = save_data["antialiasing"]
		_apply_antialiasing()
	
	# Kontrol tuşlarını yükle
	_load_controls(save_data)

func save_game_state():
	var save_data = {
		"music": music,
		"sfx": sfx,
		"current_level": current_level,
		"unlocked_levels": unlocked_levels,
		"window_mode": window_mode,
		"antialiasing": antialiasing
	}
	
	# Kontrol tuşlarını kaydet
	_save_controls(save_data)
	
	SaveLoad.save_game(save_data)

func unlock_next_level():
	if current_level == unlocked_levels and unlocked_levels < 9:
		unlocked_levels += 1
		save_game_state()

# Manuel kontrol yenileme fonksiyonu (test için)
func reload_controls():
	var save_data = SaveLoad.load_game()
	_load_controls(save_data)



func _apply_window_mode():
	if window_mode:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _apply_antialiasing():
	match antialiasing:
		0: get_viewport().msaa_2d = Viewport.MSAA_DISABLED
		1: get_viewport().msaa_2d = Viewport.MSAA_2X
		2: get_viewport().msaa_2d = Viewport.MSAA_4X
		3: get_viewport().msaa_2d = Viewport.MSAA_8X

func _load_controls(save_data: Dictionary):
	# Kontrol tuşlarını InputMap'e yükle
	var control_actions = ["jump", "left", "right", "grab"]
	
	for action in control_actions:
		if save_data.has(action):
			var key_string = save_data[action]
			# Mevcut events'i temizle
			InputMap.action_erase_events(action)
			
			# Yeni event oluştur
			var event = InputEventKey.new()
			event.physical_keycode = _string_to_keycode(key_string)
			
			# InputMap'e ekle
			InputMap.action_add_event(action, event)

func _save_controls(save_data: Dictionary):
	# Mevcut InputMap'deki kontrol tuşlarını kaydet
	var control_actions = ["jump", "left", "right", "grab"]
	
	for action in control_actions:
		var events = InputMap.action_get_events(action)
		if events.size() > 0 and events[0] is InputEventKey:
			var key_event = events[0] as InputEventKey
			var key_string = _keycode_to_string(key_event.physical_keycode)
			save_data[action] = key_string
		else:
			# Default values
			match action:
				"jump": save_data[action] = "W"
				"left": save_data[action] = "A"
				"right": save_data[action] = "D"
				"grab": save_data[action] = "E"

func _string_to_keycode(key_string: String) -> int:
	# String'i keycode'a çevir
	match key_string.to_upper():
		"W": return KEY_W
		"A": return KEY_A
		"S": return KEY_S
		"D": return KEY_D
		"E": return KEY_E
		"Q": return KEY_Q
		"R": return KEY_R
		"F": return KEY_F
		"G": return KEY_G
		"H": return KEY_H
		"Z": return KEY_Z
		"X": return KEY_X
		"C": return KEY_C
		"V": return KEY_V
		"B": return KEY_B
		"N": return KEY_N
		"M": return KEY_M
		"SPACE": return KEY_SPACE
		"SHIFT": return KEY_SHIFT
		"CTRL": return KEY_CTRL
		"ALT": return KEY_ALT
		"UP": return KEY_UP
		"DOWN": return KEY_DOWN
		"LEFT": return KEY_LEFT
		"RIGHT": return KEY_RIGHT
		_: return KEY_W  # Default

func _keycode_to_string(keycode: int) -> String:
	# Keycode'u string'e çevir
	match keycode:
		KEY_W: return "W"
		KEY_A: return "A"
		KEY_S: return "S"
		KEY_D: return "D"
		KEY_E: return "E"
		KEY_Q: return "Q"
		KEY_R: return "R"
		KEY_F: return "F"
		KEY_G: return "G"
		KEY_H: return "H"
		KEY_Z: return "Z"
		KEY_X: return "X"
		KEY_C: return "C"
		KEY_V: return "V"
		KEY_B: return "B"
		KEY_N: return "N"
		KEY_M: return "M"
		KEY_SPACE: return "SPACE"
		KEY_SHIFT: return "SHIFT"
		KEY_CTRL: return "CTRL"
		KEY_ALT: return "ALT"
		KEY_UP: return "UP"
		KEY_DOWN: return "DOWN"
		KEY_LEFT: return "LEFT"
		KEY_RIGHT: return "RIGHT"
		_: return "W"  # Default
