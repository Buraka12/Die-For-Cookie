extends CanvasLayer

func _ready() -> void:
	$".".visible = false

func _on_restart_pressed() -> void:
	$AnimationPlayer.play_backwards("die")
	await $AnimationPlayer.animation_finished
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	$AnimationPlayer.play_backwards("die")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_exit_pressed() -> void:
	$AnimationPlayer.play_backwards("die")
	await $AnimationPlayer.animation_finished
	get_tree().quit()
