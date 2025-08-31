extends CanvasLayer

@onready var resume: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer/Resume
@onready var settings: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer3/Settings
@onready var main_menu: Button = $"blur/Panel/MarginContainer/VBoxContainer/HBoxContainer5/Main Menu"
@onready var exit: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer4/Exit

# Variables for input mapping
@onready var input_button_scene = preload("res://Scenes/input_button.tscn")
@onready var action_list = $"blur/Panel/Settings/controls"

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"jump" : "Jump",
	"left" : "Move Left",
	"right" : "Move Right",
	"grab" : "Pull-Push",
	"Info" : "Information"
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	resume.pressed.connect(unpause)
	exit.pressed.connect(get_tree().quit)
	
	#die menü bozulmaması için
	get_tree().paused = false
	
	# Load saved settings
	_load_settings()
	
	# Setup control bindings
	_create_action_list()


func _on_main_menu_pressed() -> void:

	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause()

func unpause():
	$AnimationPlayer.play_backwards("pause")
	await $AnimationPlayer.animation_finished
	$".".visible = false
	get_tree().paused = false

#Oyun durdurulur.
func pause():
	if !get_tree().paused:
		$".".visible = true
		$AnimationPlayer.play("pause")
		get_tree().paused = true
		
#settings
func _on_settings_pressed() -> void:
	$AnimationPlayer.play("settings")
	
func _on_back_pressed() -> void:
	Global.save_game_state()
	$AnimationPlayer.play_backwards("settings")
	

func _on_sounds_pressed() -> void:
	$"blur/Panel/Settings/sounds".visible = true
	$blur/Panel/Settings/graph.visible = false
	$blur/Panel/Settings/controls.visible = false

func _on_graphs_pressed() -> void:
	$"blur/Panel/Settings/sounds".visible = false
	$blur/Panel/Settings/graph.visible = true
	$blur/Panel/Settings/controls.visible = false
	
func _on_controls_pressed() -> void:
	$"blur/Panel/Settings/sounds".visible = false
	$blur/Panel/Settings/graph.visible = false
	$blur/Panel/Settings/controls.visible = true

func _load_settings() -> void:
	# Load window mode setting
	var window_check = $"blur/Panel/Settings/graph/MarginContainer/VBoxContainer/Fullscreen/Fullscreen"
	window_check.button_pressed = Global.window_mode
	
	# Load antialiasing setting
	var antialiasing_option = $"blur/Panel/Settings/graph/MarginContainer/VBoxContainer/Antialising/Antialising_options"
	antialiasing_option.selected = Global.antialiasing

# Graphics settings handlers
func _on_check_button_toggled(toggled_on: bool) -> void:
	Global.window_mode = toggled_on
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	Global.save_game_state()
	
func _on_option_button_item_selected(new_scaling: int) -> void:
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

# Input remapping functions
func _create_action_list():
	InputMap.load_from_project_settings()
	# Clear existing input buttons
	for item in action_list.get_children():
		item.queue_free()
	
	# Create input buttons
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
		button.pressed.connect(_on_input_button_pressed.bind(button, action))
		
func _on_input_button_pressed(button, action):
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
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			get_tree().root.set_input_as_handled()

func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" (Physical)")


func _on_restart_pressed() -> void:
	get_tree().reload_current_scene()
