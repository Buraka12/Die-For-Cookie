extends CanvasLayer

@onready var resume: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer/Resume
@onready var save: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer2/save
@onready var settings: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer3/Settings
@onready var main_menu: Button = $"blur/Panel/MarginContainer/VBoxContainer/HBoxContainer5/Main Menu"
@onready var exit: Button = $blur/Panel/MarginContainer/VBoxContainer/HBoxContainer4/Exit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$".".visible = false
	resume.pressed.connect(unpause)
	#save.pressed.connect()
	#settings.pressed.connect()
	main_menu.pressed.connect(returnMainMenu)
	exit.pressed.connect(get_tree().quit)
	

func returnMainMenu():
	unpause()
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		pause()

func unpause():
	$".".visible = false
	get_tree().paused = false

#Oyun durdurulur.
func pause():
	if !get_tree().paused:
		$".".visible = true
		get_tree().paused = true
