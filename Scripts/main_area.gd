extends Node2D

func  _ready() -> void:
	$AnimationPlayer.play("fade_out")
	AudioManager.play("Main")
