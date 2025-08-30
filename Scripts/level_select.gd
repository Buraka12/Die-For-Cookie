extends Control

var unlocked_levels = 1  # Başlangıçta sadece ilk level açık

func _ready():
	# Kaydedilen level bilgisini yükle
	var save_data = SaveLoad.load_game()
	if save_data.has("unlocked_levels"):
		unlocked_levels = save_data["unlocked_levels"]
	
	# Level butonlarını oluştur
	create_level_buttons()

func create_level_buttons():
	var grid = $GridContainer
	
	for i in range(9):  # 9 level için
		var level_num = i + 1
		var button = Button.new()
		button.text = "Level " + str(level_num)
		button.custom_minimum_size = Vector2(150, 100)  # Buton boyutu
		
		# Level kilitli mi kontrolü
		if level_num > unlocked_levels:
			button.disabled = true
			button.text += "\n🔒"  # Kilit emoji'si
		
		# Butona tıklama fonksiyonu ekle
		button.pressed.connect(_on_level_button_pressed.bind(level_num))
		
		# Butonu grid'e ekle
		grid.add_child(button)

func _on_level_button_pressed(level_num: int):
	# Seçilen leveli yükle
	get_tree().change_scene_to_file("res://Scenes/levels/level_%d.tscn" % level_num)

func _on_back_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
