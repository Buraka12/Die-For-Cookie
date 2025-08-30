extends Node2D

@onready var ray_cast = $RayCast2D
@onready var line = $Line2D

var reflected_laser_scene = preload("res://Scenes/laser.tscn")
var reflected_lasers = []

func _ready():
	line.clear_points()

func _process(_delta):
	update_laser()

func update_laser():
	# Clear previous line points and remove old reflected lasers
	line.clear_points()
	for laser in reflected_lasers:
		laser.queue_free()
	reflected_lasers.clear()
	
	# Add starting point
	line.add_point(Vector2.ZERO)
	
	var current_ray = ray_cast
	var current_origin = global_position
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	
	while true:
		var collision = current_ray.get_collision_point()
		if current_ray.is_colliding():
			# Add collision point to the line
			line.add_point(current_ray.to_local(collision))
			
			# Check if we hit a mirror
			var collider = current_ray.get_collider()
			if collider and collider.is_in_group("mirror"):
				# Calculate reflection
				var normal = current_ray.get_collision_normal()
				var reflect_direction = current_direction.bounce(normal)
				
				# Create new reflected laser
				var reflected_laser = reflected_laser_scene.instantiate()
				add_child(reflected_laser)
				reflected_lasers.append(reflected_laser)
				
				# Position and rotate the reflected laser
				reflected_laser.global_position = collision
				reflected_laser.rotation = reflect_direction.angle()
				
				# Update for next iteration
				current_ray = reflected_laser.get_node("RayCast2D")
				current_origin = collision
				current_direction = reflect_direction
			else:
				break
		else:
			# Add end point if no collision
			line.add_point(current_ray.target_position)
			break
