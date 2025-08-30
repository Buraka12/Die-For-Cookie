extends Sprite2D

@export var demand : float = 1.0
@export var object : Node2D

var weight_object : RigidBody2D
var active : bool = false

func _ready() -> void:
	$Label.text = str(int(demand))

func _process(delta: float) -> void:
	if weight_object and !active:
		print(weight_object.mass)
		if weight_object.mass >= demand:
			action(true)
			active = true
		elif active:
			active = false
			action(false)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RigidBody2D:
		weight_object = body


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is RigidBody2D:
		weight_object = null

func action(state:bool):
	if state:
		object.active()
	else:
		object.deactive()
