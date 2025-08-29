class_name  Player
extends CharacterBody2D

var direction : float
const SPEED = 170
const JUMP_VELOCITY = -300
const ACCELERATION = 800
const DECELERATION = 950
var health = 2

enum states {IDLE,RUN,FALL,PULSH,INTERACT}
var current_state : states = states.IDLE
var grabbed_body: RigidBody2D = null

var can_interact : bool = false
var interacted : Sprite2D = null

var corpse_scene = preload("res://Scenes/corpse.tscn")
var death_position : Vector2
var can_die : bool = true
@onready var respawn_point = $"../respawn_point"

@export var camera_limit_left : int = -100000
@export var camera_limit_right : int = 100000
@export var camera_limit_up : int = -100000
@export var camera_limit_down : int = 100000


func _ready() -> void:
	$Camera2D.limit_bottom = camera_limit_down
	$Camera2D.limit_left = camera_limit_left
	$Camera2D.limit_right= camera_limit_right
	$Camera2D.limit_top = camera_limit_up
	
	#healh'ı yükle
	$ui/Playerui/Sprite2D.frame = health

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if current_state != states.FALL:
			current_state = states.FALL
			$Visual/AnimatedSprite2D.play("fall")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		$Visual/AnimatedSprite2D.play("jump")
	
	if chec_interact():
		interact()
	
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
	if current_state != states.PULSH and current_state != states.INTERACT:  # pulsh değilken değiştir
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
	elif current_state != states.INTERACT:
		if direction:
			# Acceleration
			velocity.x = move_toward(velocity.x, target_speed * direction, ACCELERATION * delta)
		else:
			# Deceleration
			velocity.x = move_toward(velocity.x, 0, DECELERATION * delta)
	
	#Animations
	if is_on_floor() and current_state != states.PULSH and current_state != states.INTERACT:
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

func chec_interact():
	return can_interact and interacted and current_state == states.IDLE and Input.is_action_just_pressed("grab")

func interact():
	velocity.x = 0
	current_state = states.INTERACT
	$Visual/AnimatedSprite2D.play("interact_button1")
	$Visual/AnimatedSprite2D.animation_finished.connect(func():
		if $Visual/AnimatedSprite2D.animation == "interact_button1":
			interacted.object.active()
			interacted.frame = 1
			$Visual/AnimatedSprite2D.play("interact_button2")
			await get_tree().create_timer(0.25).timeout
			current_state = states.IDLE
	)

#Die
func die():
	if can_die:
		
		can_die = false
		death_position = global_position
		health -=1
		$ui/Playerui/Sprite2D.frame = health
		

		if health > 0:
			#await get_tree().process_frame
			global_position = respawn_point.global_position
			velocity = Vector2.ZERO
	
			await get_tree().create_timer(0.01).timeout
			call_deferred("_spawn_corpse",death_position)
			can_die = true
		
		#ölüm menüsü yapınca koy
		else:
			print("Öldü")
			get_tree().paused = true
			$ui/Die_Menu/AnimationPlayer.play("die")

func _spawn_corpse(pos : Vector2):
	var corpse = corpse_scene.instantiate()
	corpse.global_position = death_position
	corpse.global_position.y -= 10
	corpse.linear_velocity = Vector2.ZERO
	corpse.angular_velocity = 0
	get_parent().add_child(corpse)
	await get_tree().physics_frame
	corpse.linear_velocity = Vector2.ZERO
	corpse.angular_velocity = 0

func is_facing_object(body: Node2D) -> bool:
	var is_facing_right = $Visual.scale.x > 0
	var direction_to_object = body.global_position.x - global_position.x
	
	# Karakter sağa bakıyorsa ve nesne sağdaysa, veya
	# Karakter sola bakıyorsa ve nesne soldaysa true döner
	return (is_facing_right and direction_to_object > 0) or \
		   (not is_facing_right and direction_to_object < 0)
