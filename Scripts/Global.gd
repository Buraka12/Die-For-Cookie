extends Node

static var music : float = 0
static var sfx : float = 0.5
var current_level : int = 1
var unlocked_levels : int = 1
var window_mode : bool = false
var antialiasing : int = 0

var firs_time : bool = true

func _ready():
	# Kayıtlı oyun verilerini yükle
	load_game_state()

func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_game_state()
		get_tree().quit()

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

func save_game_state():
	var save_data = {
		"music": music,
		"sfx": sfx,
		"current_level": current_level,
		"unlocked_levels": unlocked_levels,
		"window_mode": window_mode,
		"antialiasing": antialiasing
	}
	SaveLoad.save_game(save_data)

func unlock_next_level():
	if current_level == unlocked_levels and unlocked_levels < 9:
		unlocked_levels += 1
		save_game_state()



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
