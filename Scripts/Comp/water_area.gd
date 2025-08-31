extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if not is_instance_valid(body):
		return
	if body.is_in_group("floatable") and body.has_method("set_water_level"):
		body.current_water_level_y = global_position.y


func _on_body_exited(body: Node2D) -> void:
	if not is_instance_valid(body):
		return
	if body.is_in_group("floatable") and body.has_method("set_water_level"):
		body.current_water_level_y = null
