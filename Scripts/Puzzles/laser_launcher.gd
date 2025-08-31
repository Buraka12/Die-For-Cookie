extends Node2D

@onready var ray_cast = $RayCast2D
@onready var line = $Line2D
var current_bounces = []

@export var active : bool = true

@export var objects : Array[Sprite2D]

func _ready() -> void:
	# Laser başlangıçta yukarı bakıyor
	line.clear_points()

func _process(_delta: float) -> void:
	line.clear_points()
	if objects.is_empty():
		if active:
			AudioManager.play("Laser")
			update_laser()
			
		return
	
	for i in objects:
		if !i.active:
			$Sprite2D.frame = 1
			$PointLight2D.visible = false
			return
	
	active = true
	$PointLight2D.visible = true
	$Sprite2D.frame = 0
	
	
	update_laser()

func update_laser() -> void:
	
	line.clear_points()
	current_bounces.clear()
	
	var current_position = global_position
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	line.add_point(to_local(current_position))
	
	# Maksimum yansıma sayısı
	var max_bounces = 10
	var current_bounce = 0
	
	while current_bounce < max_bounces:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(current_position, current_position + current_direction * 1000)
		query.collision_mask = ray_cast.collision_mask
		
		var result = space_state.intersect_ray(query)
		
		if result:
			var collision_point = result.position
			line.add_point(to_local(collision_point))
			current_bounces.append(collision_point)
			
			var collider = result.collider
			
			# Player'a çarparsa öldür
			if collider.is_in_group("player"):
				collider.die()
				break
			# Aynaya çarparsa yansıt
			elif collider.is_in_group("mirror"):
				var normal = result.normal
				current_direction = current_direction.bounce(normal)
				current_position = collision_point + current_direction * 0.1
				current_bounce += 1
			# Cube, Corpse veya TileMap'e çarparsa dur
			elif collider.is_in_group("panel"):
				collider.get_parent().working = true
				break
			elif collider.is_in_group("cube") or collider.is_in_group("corpse") or collider is TileMap:
				break
			else:
				break
		else:
			line.add_point(to_local(current_position + current_direction * 1000))
			break

func interaction():
	active = true
	
func deinteraction():
	active = false
