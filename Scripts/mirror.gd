extends StaticBody2D

var lasered : bool = false

var laser_scene : PackedScene = load("res://Scenes/laser.tscn")
var crated : bool = false
var laser
var creator : Vector2

var timer : Timer

func _ready():
	add_to_group("mirror")
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 0.1
	timer.timeout.connect(check_laser)
	timer.start()

func check_laser():
	if lasered and !crated:
		print("Yeni")
		crated = true
		var new_laser = laser_scene.instantiate()
		new_laser.position = $LaserPoint.position
		add_child(new_laser)
		new_laser.rotation = 0
		laser = new_laser
	elif !lasered and crated:
		print("Kapat")
		crated = false
		laser.queue_free()
	timer.start()
	lasered = false
