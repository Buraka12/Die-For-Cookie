extends Sprite2D

@export var demand : float = 1.0
@export var object : Node2D

var weight_object : RigidBody2D
var active : bool = false

var timer : Timer

func _ready() -> void:
	$Label.text = str(int(demand))
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.1
	add_child(timer)
	timer.timeout.connect(_timeout)
	timer.start()

func _timeout() -> void:
	if weight_object:
		if weight_object.weight >= demand and !active:
			action(true)
			active = true
		elif weight_object.weight < demand and active:
			action(false)
			active = false
	elif weight_object == null and active:
		action(false)
		active = false
	weight_object = null
	timer.start()

func action(state:bool):
	if state:
		frame = 1
		object.interaction()
	else:
		frame = 0
		object.deinteraction()
