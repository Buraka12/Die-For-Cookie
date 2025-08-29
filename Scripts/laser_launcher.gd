extends Node2D

var laser_scene : PackedScene = load("res://Scenes/laser.tscn")

@export var can_laser : bool = true
var shooted : bool = false

func _process(delta: float) -> void:
	if can_laser and !shooted:
		shooted = true
		laser()
		

func laser():
	var new_laser = laser_scene.instantiate()
	new_laser.position = $LaserPoint.position
	$".".add_child(new_laser)
