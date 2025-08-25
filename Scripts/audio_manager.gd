extends Node


var active_music_Stream : AudioStreamPlayer

@export_group("Main")
@export var clips:Node

func play(audio_name:String , from_position:float = 0.0) -> void:
	pass
	active_music_Stream = clips.get_node(audio_name)
	active_music_Stream.play(from_position)
	
	
