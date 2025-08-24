extends Node2D

func _ready() -> void:
	print("sad")
	$AnimationPlayer.play("fade_out")
