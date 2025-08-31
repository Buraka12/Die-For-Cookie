extends CanvasLayer

func _ready():
	update_level_label()

func _process(_delta):
	update_level_label()

func update_level_label():
	var current_scene = get_tree().current_scene.scene_file_path
	if "level_" in current_scene:
		var level_number = current_scene.split("level_")[1].split(".")[0]
		$Level.text = "Level " + level_number
