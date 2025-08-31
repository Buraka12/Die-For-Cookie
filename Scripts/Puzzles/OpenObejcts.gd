extends Node2D

var done : bool = false

@export var objects : Array[Sprite2D]

func _process(_delta: float) -> void:
	
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
	$PointLight2D.color = Color("00cc05")
	$AnimationPlayer.play("Active")

func deinteraction():
	$PointLight2D.color = Color("bd0905")
	$AnimationPlayer.play_backwards("Active")
