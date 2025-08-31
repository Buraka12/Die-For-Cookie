extends Sprite2D

var active : bool = false

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.can_interact = true
		body.interacted = $"."

func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.can_interact = false
		body.interacted = null

func interact():
	active = true
	
func deinteract():
	active = false
