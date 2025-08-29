extends Node2D


func active():
	$AnimationPlayer.play("Active")

func deactive():
	$AnimationPlayer.play_backwards("Active")
