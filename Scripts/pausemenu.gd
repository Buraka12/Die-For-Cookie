extends CanvasLayer

@onready var resume: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer/Resume
@onready var settings: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer3/Settings
@onready var main_menu: Button = $"blur/Panel/MarginContainer/VBoxContainer/HBoxContainer5/Main Menu"
@onready var exit: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer4/Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	resume.pressed.connect(unpause)
	exit.pressed.connect(get_tree().quit)
	
	#die menü bozulmaması için
	get_tree().paused = false


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
	
