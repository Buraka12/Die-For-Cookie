extends RigidBody2D

var is_player_near = false
var push_speed = 70

var float_strength = 30
var current_water_level_y = null  # suya girdiğinde güncellenecek

@export var weight : int = 1

func _physics_process(_delta: float) -> void:
	$GrabArea.rotation = 0
	$GrabArea.global_rotation = 0
	$MassArea.rotation = 0
	$MassArea.global_rotation = 0
	if current_water_level_y:
		var depth = global_position.y - current_water_level_y
		if depth > 0:
			linear_velocity.y = -25

func _on_grab_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and body.grabbed_body == null:
		body.grabbed_body = $"."
		is_player_near = true

func _on_grab_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") and body.grabbed_body == $".":
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


func _on_mass_area_body_entered(body: Node2D) -> void:
	if body is RigidBody2D and body != $".":
		weight+=body.weight
		print($".","   ",weight)

func _on_mass_area_body_exited(body: Node2D) -> void:
	if body is RigidBody2D and body.get_parent() != $".":
		if weight > 1:
			weight-=body.weight
