extends Node2D


func interaction():
	$AnimationPlayer.play("Active")

func deinteraction():
	$AnimationPlayer.play_backwards("Active")
