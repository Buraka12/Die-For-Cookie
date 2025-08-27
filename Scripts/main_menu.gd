extends Control

const scaling_default : int = 0
var level

func _ready() -> void:
	var dict : Dictionary = SaveLoad.load_game()
	level = dict["level"]
	AudioManager.play("Main")
	set_scaling(scaling_default)
	$"Buttons&settings/Settings/graph/MarginContainer/VBoxContainer/Antialising/OptionButton".selected = scaling_default
#Buttons

func _on_continue_pressed() -> void:
	$AnimationPlayer.play("opening")
	$AnimatedSprite2D.play("opening")
	print(level)
	

func _on_new_game_pressed() -> void:
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
		get_tree().change_scene_to_file("res://Scenes/main_area.tscn")
		
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
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
#Antialising
func set_scaling(new_scaling : int) -> void:
	match new_scaling:
		0:
			get_viewport().msaa_2d = Viewport.MSAA_DISABLED
		1:
			get_viewport().msaa_2d = Viewport.MSAA_2X
		2:
			get_viewport().msaa_2d = Viewport.MSAA_4X
		3:
			get_viewport().msaa_2d = Viewport.MSAA_8X
		
func _on_option_button_item_selected(new_scaling: int) -> void:
	set_scaling(new_scaling)
	
	
