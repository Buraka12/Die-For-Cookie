extends Control

const scaling_default : int = 0
var level

func _ready() -> void:
	#levelleri yükle
	var dict : Dictionary = SaveLoad.load_game()
	if dict.has("current_level"):
		level = dict["current_level"]
	else:
		level = 1
	
	# Ses ayarlarını yükle
	if dict.has("music"):
		Global.music = dict["music"]
	if dict.has("sfx"):
		Global.sfx = dict["sfx"]
	
	AudioManager.play("Main")
	
	# Grafik ayarlarını yükle ve uygula
	if dict.has("antialiasing"):
		set_scaling(dict["antialiasing"])
	else:
		set_scaling(scaling_default)
	
	$"Buttons&settings/Settings/graph/MarginContainer/VBoxContainer/Antialising/OptionButton".selected = Global.antialiasing
	
	# Pencere modunu ayarla
	if dict.has("window_mode"):
		_on_check_button_toggled(dict["window_mode"])
	
	#control list creating
	_create_action_list()
	
#Buttons

func _on_continue_pressed() -> void:
	$AnimationPlayer.play("continue")
	_setup_level_buttons()
	

func _on_new_game_pressed() -> void:
	level = null  # Yeni oyun için level değerini sıfırla
	$AnimationPlayer.play("opening")
	$AnimatedSprite2D.play("opening")

func _on_settings_pressed() -> void:
	$AnimationPlayer.play("settings")

func _on_back_pressed() -> void:
	$AnimationPlayer.play_backwards("settings")


func _on_exit_pressed() -> void:
	get_tree().quit()

#Playe fade animation
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="opening":
		if level == null:  # New Game seçeneği için
			get_tree().change_scene_to_file("res://Scenes/levels/level_1.tscn")
		else:  # Continue seçeneği için
			get_tree().change_scene_to_file("res://Scenes/main_area.tscn")
		
#credits
func _on_credits_pressed() -> void:
	$AnimationPlayer.play("credits")

func _on_backc_pressed() -> void:
	$AnimationPlayer.play_backwards("credits")

func _on_back_continue_pressed() -> void:
	$AnimationPlayer.play_backwards("continue")



#Settings Menu
func _on_sounds_pressed() -> void:
	$"Buttons&settings/Settings/sounds".visible = true
	$"Buttons&settings/Settings/graph".visible = false
	$"Buttons&settings/Settings/controls".visible = false

func _on_graphs_pressed() -> void:
	$"Buttons&settings/Settings/sounds".visible = false
	$"Buttons&settings/Settings/graph".visible = true
	$"Buttons&settings/Settings/controls".visible = false
	
func _on_controls_pressed() -> void:
	$"Buttons&settings/Settings/sounds".visible = false
	$"Buttons&settings/Settings/graph".visible = false
	$"Buttons&settings/Settings/controls".visible = true


#Graphics
#Fullscreen mode
func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.window_mode = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Global.save_game_state()
		
#Antialising
func set_scaling(new_scaling : int) -> void:
	Global.antialiasing = new_scaling
	match new_scaling:
		0:
			get_viewport().msaa_2d = Viewport.MSAA_DISABLED
		1:
			get_viewport().msaa_2d = Viewport.MSAA_2X
		2:
			get_viewport().msaa_2d = Viewport.MSAA_4X
		3:
			get_viewport().msaa_2d = Viewport.MSAA_8X
	Global.save_game_state()
		
func _on_option_button_item_selected(new_scaling: int) -> void:
	set_scaling(new_scaling)

#Control settings
@onready var input_button_scene = preload("res://Scenes/input_button.tscn")
@onready var action_list = $"Buttons&settings/Settings/controls"

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"jump" : "Jump",
	"left" : "Move Left",
	"right" : "Move Right",
	"grab" : "Pull-Push",
}

func _create_action_list():
	InputMap.load_from_project_settings()
	#action listi temizleme
	for item in action_list.get_children():
		item.queue_free()
	
	#action list yazdır
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		action_label.text = input_actions[action]
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" (Physical)")
		else:
			input_label.text = ""
		
		action_list.add_child(button)
		button.pressed.connect(_on_input_button_pressed.bind(button , action))
		
func _on_input_button_pressed(button , action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key.."
		
func _input(event):
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			InputMap.action_erase_events(action_to_remap)
			InputMap.action_add_event(action_to_remap,event)
			_update_action_list(remapping_button,event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
			
func  _update_action_list(button , event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")

func _setup_level_buttons() -> void:
	var grid = $"Buttons&settings/ContinuePanel/GridContainer"
	for i in range(9):
		var button = grid.get_node("Level_" + str(i + 1))
		var level_num = i + 1
		button.text = str(level_num)
		
		# Check if level is unlocked
		if level_num <= Global.unlocked_levels:
			button.disabled = false
			button.pressed.connect(_on_level_button_pressed.bind(level_num))
		else:
			button.disabled = true
		
func _on_level_button_pressed(level_num: int) -> void:
	Global.current_level = level_num
	Global.save_game_state()
	get_tree().change_scene_to_file("res://Scenes/levels/level_" + str(level_num) + ".tscn")
