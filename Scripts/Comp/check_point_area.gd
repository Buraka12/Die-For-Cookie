extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if not is_instance_valid(body):
		return
	if body.is_in_group("player"):
		body.respawn_point = self
