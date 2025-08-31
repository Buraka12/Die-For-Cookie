extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if not is_instance_valid(body):
		return
	if body.is_in_group("player") and body.has_method("die"):
		# Web'de güvenli çağrı için defer kullan
		call_deferred("_safe_kill_player", body)

func _safe_kill_player(body: Node2D) -> void:
	if is_instance_valid(body):
		body.die()
