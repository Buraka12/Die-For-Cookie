extends Control

func _ready() -> void:
	$SettingsMenu.visible = false
	

func _on_start_pressed() -> void:
	$AnimationPlayer.play("fade_in")
	
func _on_settings_pressed() -> void:
	$"Buttons&Label".visible = false
	$SettingsMenu.visible = true
	
func _on_back_pressed() -> void:
	$"Buttons&Label".visible = true
	$SettingsMenu.visible = false

func _on_quit_pressed() -> void:
	get_tree().quit()
	
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name=="fade_in":
		get_tree().change_scene_to_file("res://Scenes/main_area.tscn")
