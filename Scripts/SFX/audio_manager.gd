extends Node

var active_music_stream : AudioStreamPlayer

@export_group("Main")
@export var clips : Node

func play(audio_name : String,from_position :float = 0.0,skip_restrat:bool = false) -> void:
	if skip_restrat and active_music_stream	and active_music_stream.name == audio_name :
		return
	
	active_music_stream = clips.get_node(audio_name)
	active_music_stream.play(from_position)

func stop():
	for i in clips.get_children():
		if i.name != "Main":
			i.stop()

func _on_music_timer_timeout() -> void:
	if !clips.get_node("Main").is_playing():
		play("Main")
