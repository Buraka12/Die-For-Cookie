extends RigidBody2D

var is_player_near = false
var push_speed = 70

func _on_grab_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.grabbed_body = $"."
		is_player_near = true

func _on_grab_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.grabbed_body = null
		is_player_near = false

func push(direction:float,extra_speed):
	if is_player_near:
		print("İt")
		linear_velocity.x = direction * (push_speed+extra_speed)
	else:
		linear_velocity.x = 0
