extends RigidBody2D

var is_player_near = false
var push_speed = 70

func _process(delta):
	$GrabArea.rotation = 0
	$GrabArea.global_rotation = 0

func _on_grab_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.grabbed_body == null:
		body.grabbed_body = $"."
		is_player_near = true

func _on_grab_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body.grabbed_body == $".":
		print("Nasıl")
		body.current_state = body.states.IDLE
		body.grabbed_body = null
		is_player_near = false

func push(direction:float,extra_speed):
	if is_player_near:
		linear_velocity.x = direction * (push_speed+extra_speed)
		$GrabArea.rotation = 0
		$GrabArea.global_rotation = 0
	else:
		linear_velocity.x = 0
