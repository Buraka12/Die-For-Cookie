extends Sprite2D

@export var object : Node2D = null

@export var demand : bool = false
var active : bool = false
var done : bool = false

var timer : Timer

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.2
	timer.timeout.connect(time)
	timer.start()

func time():
	if active:
		frame = 1
	else:
		frame = 0
	if active == demand and !done:
		object.interaction()
		done = true
	elif active != demand and done:
		done = false
		object.deinteraction()
	active = false
	timer.start()
