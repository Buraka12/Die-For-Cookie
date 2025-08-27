class_name  Player
extends CharacterBody2D

const SPEED = 170
const JUMP_VELOCITY = -250
var health = 9

var acceleration = 0.09
var deceleration = 0.09

enum states {IDLE,RUN,FALL,PULSH}
var current_state : states = states.IDLE
var is_grabbing: bool = false
var grabbed_body: RigidBody2D = null
@onready var grab_area: Area2D = $GrabArea

var corpse_scene = preload("res://Scenes/corpse.tscn")

@onready var respawn_point: Marker2D = $"../respawn_point"

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if current_state != states.FALL:
			current_state = states.FALL
			$AnimatedSprite2D.play("fall")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$AnimatedSprite2D.play("jump")

	# Grab logic
	if Input.is_action_just_pressed("grab"):
		if not is_grabbing:
			grabbed_body = get_grabbable_body()
			if grabbed_body:
				is_grabbing = true
				current_state = states.PULSH
		else:
			if grabbed_body:
				grabbed_body.freeze = false
				grabbed_body.linear_velocity = velocity
			is_grabbing = false
			grabbed_body = null

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	#flip sprite
	if current_state != states.PULSH:  # pulsh değilken değiştir
		if direction > 0:
			$AnimatedSprite2D.flip_h = false
		elif direction < 0:
			$AnimatedSprite2D.flip_h = true

	#moving
	var target_speed = SPEED
	if current_state == states.PULSH:
		target_speed = 70
	
	if direction:
		velocity.x = move_toward(velocity.x, direction * target_speed, target_speed * acceleration)
	elif not direction and current_state != states.FALL:
		velocity.x = move_toward(velocity.x, 0, target_speed * deceleration)
	
	# Pull/Push movement
	if is_grabbing and grabbed_body:
		current_state = states.PULSH
		
		#karakterden uzaklığı
		var offset = 18.5
		if $AnimatedSprite2D.flip_h:
			offset *= -1
		
		
		var target_x = global_position.x + offset
		grabbed_body.global_position.x = target_x
		grabbed_body.global_position.y = global_position.y  
		
		grabbed_body.linear_velocity = velocity
		
		#PULSH animation
		if (offset > 0 and direction > 0) or (offset < 0 and direction < 0):
			$AnimatedSprite2D.play("push")
		else:
			$AnimatedSprite2D.play("pull")
		
		grabbed_body.rotation = 0
		grabbed_body.angular_velocity = 0
		grabbed_body.freeze = true
	
	elif not is_grabbing and grabbed_body != null:
		grabbed_body.freeze_mode = RigidBody2D.FREEZE_MODE_STATIC
		grabbed_body = null
	#animations
	if is_on_floor() and not is_grabbing:
		if direction == 0 and current_state != states.FALL:
			current_state = states.IDLE
			$AnimatedSprite2D.play("idle")
		else:
			current_state = states.RUN
			$AnimatedSprite2D.play("move")
	
	move_and_slide()
	
	#die
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

func get_grabbable_body() -> RigidBody2D:
	for body in grab_area.get_overlapping_bodies():
		if body is RigidBody2D:
			return body
	return null
