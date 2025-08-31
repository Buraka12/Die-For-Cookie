extends Area2D

func _ready():
	body_entered.connect(_on_body_entered)

func get_current_level_number() -> int:
	var current_scene = get_tree().current_scene.scene_file_path
	var regex = RegEx.new()
	regex.compile("level_(\\d+)")
	var result = regex.search(current_scene)
	if result:
		return result.get_string(1).to_int()
	return 1

func _on_body_entered(body):
	if body.is_in_group("player"):
		var current_level = get_current_level_number()
		var next_level = current_level + 1
		
		# Global değişkenleri güncelle
		Global.firs_time = true
		Global.current_level = next_level
		if next_level > Global.unlocked_levels:
			Global.unlocked_levels = next_level
		
		# Değişiklikleri kaydet
		Global.save_game_state()

		
		var next_level_path = "res://Scenes/levels/level_%d.tscn" % next_level
		get_tree().call_deferred("change_scene_to_file", next_level_path)
