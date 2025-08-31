extends Node

const save_location : String = "user://SaveFile.json"
const default_dict : Dictionary = {
	"level": 1,
	"unlocked_levels": 1,
	"current_level": 1,
	"music": 0.5,
	"sfx": 0.5,
	"antialiasing": 0,
	"window_mode": false,
	"jump": "W",
	"right": "D",
	"left": "A",
	"grab": "E",
}

func save_game(data : Dictionary) -> void:
	var save_file : FileAccess = FileAccess.open(save_location , FileAccess.WRITE)
	if save_file == null:
		push_error("SaveFile açılamadı: " + str(FileAccess.get_open_error()))
		return
	var string_data : String = JSON.stringify(data)
	save_file.store_line(string_data)
	save_file.close()
	
func load_game() -> Dictionary:
	if not FileAccess.file_exists(save_location):
		return default_dict.duplicate()
		
	var save_file : FileAccess = FileAccess.open(save_location, FileAccess.READ)
	if save_file == null :
		push_error("SaveFile okunamadı: " + str(FileAccess.get_open_error()))
		return default_dict.duplicate()
	
	var json = JSON.new()
	var string_data: String = save_file.get_line()
	save_file.close()
	
	if json.parse(string_data) == OK:
		var data : Dictionary = json.get_data()
		if typeof(data) == TYPE_DICTIONARY:
			return data
		else:
			push_error("Save dosyası geçersiz format")
			return default_dict.duplicate()
	else:
		push_error("JSON parse hatası: " + json.error_string)
		return default_dict.duplicate()
