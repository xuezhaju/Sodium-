extends Node


var is_dark:String = "true"

var mode:String = "txt"

signal code_light_changed(enabled: bool)

var title_font:String = "res://asset/SmileySans-Oblique.ttf"
var main_font:String = "res://asset/SmileySans-Oblique.ttf"
var music_path:String = ""
var Dark_icon_path:String = "res://asset/item/dark.png"
var Light_icon_path:String = "res://asset/item/light.png"

var main_color = Color(0.145, 0.478, 0.439)
var back_color = Color(0.161, 0.161, 0.161)
var title_font_color = Color(1.0, 1.0, 1.0)
var main_font_color = Color(1.0, 1.0, 1.0)

var save_cfg_path:String = "C://Users/sodium_settins"

var sound_db:float = 0

var code_light:bool = false:
	set(value):
		if code_light != value:
			code_light = value
			code_light_changed.emit(code_light)

var music_play:bool = true

var minimap:bool = true

var db:float = 0.0

var font_size: int = 16.0

# 音量范围 (转换为线性值)
const MIN_DB = -30.0  # 最小音量对应的分贝值
const MAX_DB = 0.0    # 最大音量对应的分贝值

var master_volume_linear := 0.8:  
	set(value):
		master_volume_linear = clamp(value, 0.0, 1.0)
		# 转换为分贝并设置到音频总线
		var db_volume = linear_to_db(master_volume_linear)
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), db_volume)
		# 保存设置
		save_volume()

func _ready():
	load_volume()
	load_settings()

func save_volume():
	var config = ConfigFile.new()
	config.set_value("audio", "master_volume", master_volume_linear)
	config.save("user://settings.cfg")

func load_volume():
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		master_volume_linear = config.get_value("audio", "master_volume", 0.8)
			
			
func load_settings():
	var config = ConfigFile.new()
	var result = config.load(save_cfg_path)
	if not FileAccess.file_exists(save_cfg_path):
		push_error("配置文件不存在: ", save_cfg_path)
		save_settings()
	
	if result != OK:
		printerr("erro on load settings cfg!")
		title_font = "res://asset/SmileySans-Oblique.ttf"
		main_font = "res://asset/SmileySans-Oblique.ttf"
		music_path = ""
		Dark_icon_path = "res://asset/item/dark.png"
		Light_icon_path = "res://asset/item/light.png"

		main_color = Color(0.145, 0.478, 0.439)
		back_color = Color(0.161, 0.161, 0.161)
		title_font_color = Color(1.0, 1.0, 1.0)
		main_font_color = Color(1.0, 1.0, 1.0)
	else:
		title_font = config.get_value("Settings", "title_font", "res://asset/SmileySans-Oblique.ttf")
		main_font = config.get_value("Settings", "main_font", "res://asset/SmileySans-Oblique.ttf")
		music_path = config.get_value("Settings", "music_path", "res://asset/SmileySans-Oblique.ttf")

		main_color = config.get_value("Settings", "main_color", Color(0.145, 0.478, 0.439))
		back_color = config.get_value("Settings", "back_color", Color(0.161, 0.161, 0.161))
		title_font_color = config.get_value("Settings", "title_font_color", Color(1.0, 1.0, 1.0))
		main_font_color = config.get_value("Settings", "main_font_color", Color(1.0, 1.0, 1.0))
	
	
func save_settings():
	var config = ConfigFile.new()
	config.set_value("Settings", "main_color", Global.main_color)
	config.set_value("Settings", "back_color", Global.back_color)
	config.set_value("Settings", "title_font_color", Global.title_font_color)
	config.set_value("Settings", "main_font_color", Global.main_font_color)
	config.set_value("Settings", "is_dark", Global.is_dark)
	config.set_value("Settings", "title_font_color", Global.title_font_color)
	config.set_value("Settings", "code_light", Global.code_light)
	config.set_value("Settings", "music_play", Global.music_play)
	config.set_value("Settings", "minimap", Global.minimap)
	config.set_value("Settings", "title_font", Global.title_font)
	config.set_value("Settings", "main_font", Global.main_font)
	config.set_value("Settings", "music_path", Global.music_path)
	config.set_value("Settings", "font_size", Global.font_size)
	
	config.save(Global.save_cfg_path)


func is_file_of_type(file_path: String, expected_extension: String) -> bool:
	return file_path.get_extension().to_lower() == expected_extension.to_lower()
