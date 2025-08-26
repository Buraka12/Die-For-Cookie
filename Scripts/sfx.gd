extends HSlider

@export var bus_name :String

var bus_id

func _ready() -> void:
	#Ada göre id ataması
	bus_id = AudioServer.get_bus_index(bus_name)
	#Ses düzeyi
	value = Global.sfx

#Ses düzeyi değiştirme
func _on_value_changed(dvalue: float) -> void:
	Global.sfx = dvalue
	#Düz sayıyı desibel'e çevirme
	var db = linear_to_db(dvalue)
	#Ses düzeyi ataması
	AudioServer.set_bus_volume_db(bus_id,db)
