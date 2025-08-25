extends CharacterBody2D

const SPEED = 200
const JUMP_VELOCITY = -300

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	#flip sprite
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true

	#moving
	if direction:
		velocity.x = direction * SPEED
		
	elif not direction:
		velocity.x = move_toward(velocity.x, 0, 12)
		
		
	#animations
	if is_on_floor():
		if direction == 0:
			$AnimatedSprite2D.play("idle")
		else:
			$AnimatedSprite2D.play("move")	
	else:
		$AnimatedSprite2D.play("jump")
		
	move_and_slide()
