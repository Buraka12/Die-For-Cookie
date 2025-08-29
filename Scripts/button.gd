extends Sprite2D

@export var object : Node2D

#butona basma
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.can_interact = true
		body.interacted = $"."

#butondan ayrılma
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.can_interact = false
		body.interacted = null
