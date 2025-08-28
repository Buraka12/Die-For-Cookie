extends Node2D

@onready var ray_cast = $RayCast2D
@onready var line = $Line2D

var reflection_points: Array = []
const MAX_REFLECTIONS = 10

func _ready():
	rotation_degrees = snap_to_45(rotation_degrees)

func _process(_delta):
	update_laser()

func update_laser():
	reflection_points.clear()
	reflection_points.append(Vector2.ZERO)
	
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	var current_ray_position = global_position
	var total_distance = 0.0
	
	for _i in range(MAX_REFLECTIONS):
		ray_cast.global_position = current_ray_position
		ray_cast.global_rotation = current_direction.angle()
		ray_cast.force_raycast_update()
		
		var collision = ray_cast.get_collision_point()
		var collider = ray_cast.get_collider()
		
		if collider:
			var relative_collision = to_local(collision)
			reflection_points.append(relative_collision)
			
			if collider.is_in_group("mirror"):
				var normal = ray_cast.get_collision_normal()
				current_direction = current_direction.bounce(normal)
				current_ray_position = collision
			else:
				break
		else:
			var end_point = ray_cast.global_position + current_direction * ray_cast.target_position.length()
			reflection_points.append(to_local(end_point))
			break
	
	line.points = reflection_points

func snap_to_45(degrees: float) -> float:
	return round(degrees / 45.0) * 45.0
