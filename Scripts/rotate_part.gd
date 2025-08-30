extends Sprite2D

@export var object : Node2D = null
@export var rot_speed : float = 20
var active : bool = false


func _process(delta: float) -> void:
	if !active:
		return
	
	if Input.is_action_pressed("LeftMouse"):
		object.rotation_degrees += rot_speed*delta
	elif Input.is_action_pressed("RightMouse"):
		object.rotation_degrees -= rot_speed*delta
	
	if abs(object.rotation_degrees) == 360:
		object.rotation_degrees = 0

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
