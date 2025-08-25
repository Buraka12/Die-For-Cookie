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
	if not is_on_floor():
		$AnimatedSprite2D.play("jumps")

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	
	#flip sprite
	if direction > 0:
		$AnimatedSprite2D.flip_h = false
	elif direction < 0:
		$AnimatedSprite2D.flip_h = true
	
	#moving
	if direction and is_on_floor():
		$AnimatedSprite2D.play("move")
		velocity.x = direction * SPEED
		
	elif not direction and is_on_floor():
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, 12)

	move_and_slide()
