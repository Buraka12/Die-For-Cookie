extends Node2D

var done : bool = false

@export var objects : Array[Sprite2D]

func _process(delta: float) -> void:
	
	if objects.is_empty():
		return
	
	for i in objects:
		if !i.active:
			if done:
				done = false
				deinteraction()
			return
	
	if !done:
		done = true
		interaction()

func interaction():
	$AnimationPlayer.play("Active")

func deinteraction():
	$AnimationPlayer.play_backwards("Active")
