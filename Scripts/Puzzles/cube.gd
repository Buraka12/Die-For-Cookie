extends RigidBody2D

var is_player_near = false
var push_speed = 70

var float_strength = 30
var current_water_level_y = null  # suya girdiğinde güncellenecek

@export var weight : int = 1
var powered : bool = false

# Performance için cache değerleri
var last_rotation_reset_frame = -1

# Web safety için method eklendi
func set_water_level():
	pass

func _physics_process(delta: float) -> void:
	# Aynı frame'de rotation reset yapmayı önle
	var current_frame = Engine.get_process_frames()
	if last_rotation_reset_frame != current_frame:
		if is_instance_valid($GrabArea):
			$GrabArea.rotation = 0
			$GrabArea.global_rotation = 0
		if is_instance_valid($MassArea):
			$MassArea.rotation = 0
			$MassArea.global_rotation = 0
		if is_instance_valid($RayCast2D):
			$RayCast2D.rotation = 0
			$RayCast2D.global_rotation = 0
		last_rotation_reset_frame = current_frame
	
	# Su physics'i - Web güvenli
	if current_water_level_y != null:
		var depth = global_position.y - current_water_level_y
		if depth > 0:
			linear_velocity.y = -25
	
	# Pressure plate kontrolü - Web güvenli
	if is_instance_valid($RayCast2D) and $RayCast2D.is_colliding():
		var collider = $RayCast2D.get_collider()
		if is_instance_valid(collider) and collider.is_in_group("pressure"):
			var parent = collider.get_parent()
			if is_instance_valid(parent):
				parent.weight_object = self

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

func _on_mass_area_body_exited(body: Node2D) -> void:
	if body is RigidBody2D and body.get_parent() != $".":
		if weight > 1:
			weight-=body.weight
