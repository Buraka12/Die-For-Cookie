extends Node2D

var laser_scene : PackedScene = load("res://Scenes/laser.tscn")
var created : bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	check_ray_cast()
	draw_laser()

func check_ray_cast():
	if $RayCast2D.is_colliding() and $RayCast2D.get_collider() != $"..":
		var object = $RayCast2D.get_collider()
		var point = $RayCast2D.get_collision_point()
		#print($Line2D.points,"     ",object.name)
		$Line2D.points = [to_local(global_position),to_local(point)]
		if object.name == "Panel":
			print("Hell Yeah!")
		if object.is_in_group("mirror"):
			created = true
			object.lasered = true
			object.creator = $"..".global_position
		elif object.is_in_group("panel"):
			object.get_parent().active = true

func draw_laser():
	$Line2D.width = 3
	$Line2D.default_color = Color.RED
