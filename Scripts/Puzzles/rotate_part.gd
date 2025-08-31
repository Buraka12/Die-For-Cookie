extends Sprite2D

@export var object : Node2D = null
@export var rot_speed : float = 60
var active : bool = false

var active_music : bool = false

func _process(delta: float) -> void:
	if !active:
		return
	
	if Input.is_action_pressed("LeftMouse"):
		play_music()
		object.rotation_degrees += rot_speed*delta
		
	elif Input.is_action_pressed("RightMouse"):
		play_music()
		object.rotation_degrees -= rot_speed*delta
		
	
	if abs(object.rotation_degrees) == 360:
		object.rotation_degrees = 0

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.pressed:
			AudioManager.stop("mirror")

func play_music():
	if !active_music:
		active_music = true
		AudioManager.play("mirror")
		await get_tree().create_timer(1).timeout
		active_music = false

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.can_interact = true
		body.interacted = $"."


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.can_interact = false
		body.interacted = null

func interact():
	active = true
