class_name  Player
extends CharacterBody2D

const SPEED = 170
const JUMP_VELOCITY = -250
var health = 9

var acceleration = 0.09
var deceleration = 0.09

enum states {IDLE,RUN,FALL,PUSH}
var current_state : states

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

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	#flip sprite
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	#moving
	if direction:
		velocity.x = move_toward(velocity.x, direction * SPEED, SPEED * acceleration)
		
	elif not direction and current_state != states.FALL:
		velocity.x = move_toward(velocity.x, 0, SPEED * deceleration)
		
		
	#animations
	if is_on_floor():
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

	#can kontrolü
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
