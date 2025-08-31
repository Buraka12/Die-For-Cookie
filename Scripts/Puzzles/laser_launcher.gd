extends Node2D

@onready var ray_cast = $RayCast2D
@onready var line = $Line2D
var current_bounces = []

@export var active : bool = true
@export var invert_logic : bool = false  # Panel aktifken laser'ı kapatmak için true yap
var sound_active : bool = false

@export var objects : Array[Sprite2D]

func _ready() -> void:
	# Laser başlangıçta yukarı bakıyor
	line.clear_points()

func _process(_delta: float) -> void:
	if not is_node_ready():
		return
		
	line.clear_points()
	if objects.is_empty():
		if active:
			update_laser()
			if !sound_active:
				AudioManager.play("Laser")
				sound_active = true
				await  get_tree().create_timer(1).timeout
				sound_active = false
		return
	
	# Object validation
	for i in objects:
		if not is_instance_valid(i):
			continue
		
		# Normal logic: Panel aktif değilse laser kapalı
		# Inverted logic: Panel aktifse laser kapalı
		var should_be_off = false
		if invert_logic:
			should_be_off = i.active  # Panel aktifse kapat
		else:
			should_be_off = !i.active  # Panel aktif değilse kapat
			
		if should_be_off:
			$Sprite2D.frame = 1
			$PointLight2D.visible = false
			return
	
	# Tüm koşullar sağlanıyorsa laser launcher'ı AÇ
	active = true
	$PointLight2D.visible = true
	$Sprite2D.frame = 0
	
	if !sound_active:
		AudioManager.play("Laser")
		sound_active = true
		await  get_tree().create_timer(1).timeout
		sound_active = false
	update_laser()

func update_laser() -> void:
	# Web güvenliği kontrolü
	if not is_node_ready() or not is_instance_valid(get_world_2d()):
		return
	
	line.clear_points()
	current_bounces.clear()
	
	var current_position = global_position
	var current_direction = Vector2.RIGHT.rotated(global_rotation)
	line.add_point(to_local(current_position))
	
	# Web için maksimum yansıma sayısını azalt
	var max_bounces = 5  # Web için azaltıldı
	var current_bounce = 0
	
	# Frame limit - Web'de sonsuz döngüyü önlemek için
	var frame_limit = 100
	var frame_count = 0
	
	while current_bounce < max_bounces and frame_count < frame_limit:
		frame_count += 1
		
		var space_state = get_world_2d().direct_space_state
		if not is_instance_valid(space_state):
			break
			
		var query = PhysicsRayQueryParameters2D.create(current_position, current_position + current_direction * 1000)
		query.collision_mask = ray_cast.collision_mask
		
		var result = space_state.intersect_ray(query)
		
		if result.is_empty():
			line.add_point(to_local(current_position + current_direction * 1000))
			break
		
		var collision_point = result.position
		line.add_point(to_local(collision_point))
		current_bounces.append(collision_point)
		
		var collider = result.collider
		
		# Null check ekle
		if not is_instance_valid(collider):
			break
		
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
			var parent = collider.get_parent()
			if is_instance_valid(parent):
				parent.working = true
			break
		elif collider.is_in_group("cube") or collider.is_in_group("corpse") or collider is TileMap:
			break
		else:
			break

func interaction():
	active = true
	
func deinteraction():
	active = false
