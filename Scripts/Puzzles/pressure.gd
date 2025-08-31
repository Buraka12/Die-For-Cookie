extends Sprite2D

@export var demand : float = 1.0
@export var object : Node2D

var weight_object : RigidBody2D
var active : bool = false
var last_active_state : bool = false

var timer : Timer

func _ready() -> void:
	$Label.text = str(int(demand))
	timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = 0.1
	add_child(timer)
	timer.timeout.connect(_timeout)
	timer.start()

func _timeout() -> void:
	var new_active_state = false
	
	if weight_object and weight_object.weight >= demand:
		new_active_state = true
	
	# Sadece durum değiştiğinde güncelle
	if new_active_state != last_active_state:
		active = new_active_state
		last_active_state = active
		
		if active:
			frame = 1
			$PointLight2D.color = Color("00cc05")
		else:
			frame = 0
			$PointLight2D.color = Color("bd0905")
	
	weight_object = null
	timer.start()
