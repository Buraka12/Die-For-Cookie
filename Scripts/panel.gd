extends Sprite2D

@export var demand : bool = false
var working : bool = false
var active : bool = false

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
	if working:
		frame = 1
	else:
		frame = 0
	if working == demand:
		active = true
	elif working != demand:
		active = false
	working = false
	timer.start()
