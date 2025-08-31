extends Sprite2D

@export var object : Node2D = null
@export var rot_speed : float = 60
var active : bool = false

var active_music : bool = false
var music_timer : Timer

func _ready():
	# Timer'ı önceden oluştur
	music_timer = Timer.new()
	music_timer.wait_time = 1.0
	music_timer.one_shot = true
	add_child(music_timer)
	music_timer.timeout.connect(_on_music_timer_timeout)

func _process(delta: float) -> void:
	if not active or not is_instance_valid(object):
		return
	
	if Input.is_action_pressed("LeftMouse"):
		play_music()
		object.rotation_degrees += rot_speed * delta
		
	elif Input.is_action_pressed("RightMouse"):
		play_music()
		object.rotation_degrees -= rot_speed * delta
		
	# Rotation normalizasyonu
	if abs(object.rotation_degrees) >= 360:
		object.rotation_degrees = fmod(object.rotation_degrees, 360)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and not event.pressed:
		AudioManager.stop("mirror")

func play_music():
	if not active_music:
		active_music = true
		AudioManager.play("mirror")
		music_timer.start()

func _on_music_timer_timeout():
	active_music = false

func _on_interact_area_body_entered(body: Node2D) -> void:
	if not is_instance_valid(body):
		return
	if body.is_in_group("player"):
		body.can_interact = true
		body.interacted = self


func _on_interact_area_body_exited(body: Node2D) -> void:
	if not is_instance_valid(body):
		return
	if body.is_in_group("player"):
		body.can_interact = false
		body.interacted = null

func interact():
	active = true
