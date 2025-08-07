extends Control

@onready var open: Button = $Edit/VBoxContainer/Open
@onready var setting: Button = $Edit/VBoxContainer/Setting
@onready var settings: Control = $Settings
@onready var create: Button = $Edit/VBoxContainer/Create
@onready var creates: HBoxContainer = $mode_creates/creates
@onready var music_button: CheckButton = $Settings/VBoxContainer/MusicSetting/MusicLabel/MusicButton
@onready var line_edit: LineEdit = $Settings/VBoxContainer/MusicSetting/MusicPath/LineEdit
@onready var music_search: FileDialog = $MusicSearch
@onready var mode_creates: CenterContainer = $mode_creates
@onready var minimap: CheckButton = $Settings/Minimap
@onready var dl: Button = $Settings/DL
@onready var code_light: CheckButton = $Settings/Minimap/CodeLight
@onready var list: ColorRect = $Edit/List
@onready var backcolor: ColorPickerButton = $Settings/VBoxContainer/ColorSetting/BackColor/backcolor
@onready var main_font_input: LineEdit = $Settings/VBoxContainer/FontSetting/MainFont/LineEdit

var mode:String = "create"

func _ready() -> void:
	# 监听键盘ESC键
	set_process_unhandled_input(true)
	# 监听窗口关闭请求
	get_viewport().get_window().close_requested.connect(_on_window_close_requested)
	mode_creates.hide()
	mode_creates.process_mode = Node.PROCESS_MODE_DISABLED
	
	settings.hide()
	settings.process_mode = Node.PROCESS_MODE_DISABLED
	
	music_search.hide()
	music_search.process_mode = Node.PROCESS_MODE_DISABLED
	
	
func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:  # 按下ESC键
			get_tree().quit()  # 直接退出


func _on_open_pressed() -> void:
	Global.save_settings()
	get_tree().change_scene_to_file("res://Scene/编辑/编辑页面.tscn")

func _on_window_close_requested():
	get_tree().quit()  # 点击窗口关闭按钮时直接退出	

func _on_create_pressed() -> void:
	mode = "create"

func _music_button():
	if music_button.button_pressed:
		Global.music_play = true
	else:
		Global.music_play = false

func _minimap():
	if minimap.button_pressed:
		Global.minimap = true
	else:
		Global.minimap = false

func _codelight():
	if code_light.button_pressed:
		Global.code_light = true
	else:
		Global.code_light = false


func _on_music_button_pressed() -> void:
	Global.music_play = true

func _on_line_edit_editing_toggled(_toggled_on: bool) -> void:
	music_search.show()
	music_search.process_mode  = Node.PROCESS_MODE_INHERIT

func _on_music_search_canceled() -> void:
	line_edit.release_focus()

func _on_setting_pressed() -> void:
	mode = "setting"

func _process(_delta: float) -> void:
	_codelight()
	_dark_light()
	_minimap()
	_music_button()
	list.color = Global.main_color
	line_edit.text = Global.music_path
	match mode:
		"create":
			settings.hide()
			settings.process_mode = Node.PROCESS_MODE_DISABLED
			mode_creates.show()
			mode_creates.process_mode = Node.PROCESS_MODE_INHERIT
		
		"setting":
			mode_creates.hide()
			mode_creates.process_mode = Node.PROCESS_MODE_DISABLED
			settings.show()
			settings.process_mode = Node.PROCESS_MODE_INHERIT
			main_font_input.text = Global.main_font

func _dark_light():
	if Global.is_dark == "true":
		dl.icon = load(Global.Light_icon_path)
	else:
		dl.icon = load(Global.Dark_icon_path)

func _on_dl_pressed() -> void:
	if Global.is_dark == "true":
		Global.is_dark = "false"
		backcolor.color = Color(0.161, 0.161, 0.161)
	else:
		Global.is_dark = "true"
		backcolor.color = Color(1.0, 1.0, 1.0)
	
