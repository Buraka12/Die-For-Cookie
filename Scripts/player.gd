class_name  Player
extends CharacterBody2D

var direction : float
const SPEED = 170
const JUMP_VELOCITY = -250
const ACCELERATION = 800
const DECELERATION = 950
var health = 9

enum states {IDLE,RUN,FALL,PULSH,CLIMB}
var current_state : states = states.IDLE
var grabbed_body: RigidBody2D = null

var corpse_scene = preload("res://Scenes/corpse.tscn")

@onready var respawn_point: Marker2D = $"../respawn_point"
@onready var climb_cast : RayCast2D = $Visual/RayCast2D

func _physics_process(delta: float) -> void:
	check_climb()
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if current_state != states.FALL and current_state != states.CLIMB:
			current_state = states.FALL
			$Visual/AnimatedSprite2D.play("fall")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Visual/AnimatedSprite2D.play("jump")

	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left", "right")
	
	# Grab logic
	if Input.is_action_pressed("grab") and grabbed_body and is_facing_object(grabbed_body):
		current_state = states.PULSH
		var offset = global_position.x - grabbed_body.global_position.x
		var extra_speed : int
		if (direction<0 and offset>0) or (direction>0 and offset<0):
			extra_speed = 0
		else:
			extra_speed = 5
		grabbed_body.push(direction,extra_speed)
	
	if Input.is_action_just_released("grab") and current_state == states.PULSH:
		current_state = states.IDLE
		grabbed_body.linear_velocity.x = 0
	
	#Flip Visuals
	if current_state != states.PULSH:  # pulsh değilken değiştir
		if direction > 0:
			$Visual.scale.x = 1
		elif direction < 0:
			$Visual.scale.x = -1
	
	#Moving
	var target_speed = SPEED
	if current_state == states.PULSH:
		target_speed = 70
		if direction:
			velocity.x = target_speed * direction
		else:
			velocity.x = 0
	elif current_state != states.CLIMB:
		if direction:
			# Acceleration
			velocity.x = move_toward(velocity.x, target_speed * direction, ACCELERATION * delta)
		else:
			# Deceleration
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	
	#Animations
	if is_on_floor() and current_state != states.PULSH and current_state != states.CLIMB:
		if direction == 0:
			current_state = states.IDLE
			$Visual/AnimatedSprite2D.play("idle")
		else:
			current_state = states.RUN
			$Visual/AnimatedSprite2D.play("move")
	elif current_state == states.PULSH:
		var offset = global_position.x - grabbed_body.global_position.x
		if (direction<0 and offset>0) or (direction>0 and offset<0):
			$Visual/AnimatedSprite2D.play("push")
		else:
			$Visual/AnimatedSprite2D.play("pull")
	
	move_and_slide()

func check_climb():
	if climb_cast.is_colliding() and velocity.y > 0 and direction == $Visual.scale.x and current_state != states.CLIMB:
		climb()

func climb():
	current_state = states.CLIMB
	var tween = create_tween()
	tween.tween_property(self,"global_position",Vector2(global_position.x+direction*8,global_position.y-24),0.2)
	tween.finished.connect(func():
		current_state = states.IDLE
	)

#Die
func die():
	var death_position = global_position
	health -=1

	if health > 0:
		#await get_tree().process_frame
		global_position = respawn_point.global_position
		velocity = Vector2.ZERO

		await get_tree().create_timer(0.01).timeout
		call_deferred("_spawn_corpse",death_position)
		
	#ölüm menüsü yapınca koy
	else:
		pass

func _spawn_corpse(pos : Vector2):
	var corpse = corpse_scene.instantiate()
	corpse.global_position = pos
	get_parent().add_child(corpse)

func is_facing_object(body: Node2D) -> bool:
	var is_facing_right = $Visual.scale.x > 0
	var direction_to_object = body.global_position.x - global_position.x
	
	# Karakter sağa bakıyorsa ve nesne sağdaysa, veya
	# Karakter sola bakıyorsa ve nesne soldaysa true döner
	return (is_facing_right and direction_to_object > 0) or \
		   (not is_facing_right and direction_to_object < 0)
