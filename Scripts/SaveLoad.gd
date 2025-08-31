extends Node

const save_location : String = "user://SaveFile.json"
const default_dict : Dictionary = {
	"level": 1,
	"unlocked_levels": 1,
	"current_level": 1,
	"music": 0.5,
	"sfx": 0.5,
	"antialiasing": 0,
	"jump" : "W",
	"right" : "D",
	"left" : "A",
	"grab" : "E",

}

func save_game(data : Dictionary) -> void:
	var save_file : FileAccess = FileAccess.open(save_location , FileAccess.WRITE)
	if save_file == null:
		push_error("error opening file")
		return
	var string_data : String = JSON.stringify(data)
	save_file.store_line(string_data)
	save_file.close()
	
func load_game() -> Dictionary:
	if FileAccess.file_exists(save_location):
		var save_file : FileAccess = FileAccess.open(save_location,FileAccess.READ)
		if save_file == null :
			push_error("error reading file")
			return default_dict
		var json = JSON.new()
		
		var string_data: String = save_file.get_line()
		if json.parse(string_data) == OK:
			var data : Dictionary = json.get_data()
			save_file.close()
			return data
		push_error("Corrupted data")
		return default_dict
	return default_dict
