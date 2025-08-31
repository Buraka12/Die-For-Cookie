extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("floatable"):
		body.current_water_level_y = global_position.y


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("floatable"):
		body.current_water_level_y = null
