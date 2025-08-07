extends Control

@onready var files: MenuButton = $Files
@onready var help: MenuButton = $Help
@onready var text_edit: TextEdit = $TextEdit
@onready var save_dialog: FileDialog = $SaveMenu
@onready var open_dialog: FileDialog = $OpenMenu
@onready var quit_confirmation: ConfirmationDialog = $QuitConfirmation
@onready var show_mode: Label = $EditBack/ShowMode
@onready var return_main: ConfirmationDialog = $ReturnMain
@onready var bgm: AudioStreamPlayer = $BGM
@onready var mouse_path: Label = $EditBack/MousePath
@onready var color_rect: ColorRect = $EditBack/ColorRect

var is_modified: bool = false
var current_file_path: String = ""
var original_content: String = ""
var file_name: String = ""
var is_music: bool = true

func _ready() -> void:
	# 设置文件菜单
	var files_popup = files.get_popup()
	files_popup.clear()
	files_popup.add_item("打开", 0)
	files_popup.add_item("保存", 1)
	files_popup.add_item("另存为", 2)
	files_popup.add_separator()
	files_popup.add_item("退出", 3)
	files_popup.add_item("首页", 4)
	files_popup.id_pressed.connect(_on_files_item_selected)
	
	# 设置保存对话框
	save_dialog.file_mode = FileDialog.FILE_MODE_SAVE_FILE
	save_dialog.add_filter("*.txt;文本文件")
	save_dialog.add_filter("*.md;Markdown文件")
	save_dialog.add_filter("*.html;HTML文件")
	save_dialog.file_selected.connect(_on_save_dialog_selected)
	save_dialog.hide()

	# 设置打开对话框
	open_dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	open_dialog.add_filter("*.txt;文本文件")
	open_dialog.add_filter("*.md;Markdown文件")
	open_dialog.add_filter("*.*;所有文件")
	open_dialog.file_selected.connect(_on_open_dialog_selected)
	open_dialog.hide()
	
	# 设置退出确认对话框
	quit_confirmation.get_ok_button().text = "保存并退出"
	quit_confirmation.get_cancel_button().text = "直接退出"
	quit_confirmation.confirmed.connect(_on_quit_confirmed)
	quit_confirmation.canceled.connect(_on_quit_canceled) 
	quit_confirmation.unresizable = true
	quit_confirmation.exclusive = true
	quit_confirmation.hide()
	
	#设置ReturnMain菜单
	return_main.hide()
	return_main.process_mode = Node.PROCESS_MODE_DISABLED
	return_main.confirmed.connect(_on_ok_pressed)
	return_main.canceled.connect(_on_cancel_pressed)
	# 监听文本变化
	text_edit.text_changed.connect(_on_text_changed)
	
	files_open()
	
	# 禁用自动接受退出
	get_tree().set_auto_accept_quit(false)
	get_viewport().get_window().close_requested.connect(_on_window_close_requested)

func files_open():
	# 获取命令行参数
	var args = OS.get_cmdline_args()

	# 调试用 - 打印所有参数
	print("命令行参数: ", args)

	# 检查是否有文件路径参数
	if args.size() > 1:
		var file_path = args[-1]  # 通常最后一个参数是文件路径
		# 处理Windows的特殊参数和引号
		file_path = file_path.trim_prefix('"').trim_suffix('"')
		if file_path == "%V" or file_path == "%1":
			# 桌面右键菜单调用，但没有选择具体文件
			start_normal()
		else:
			handle_file_open(file_path)
	else:
		# 正常启动，没有文件关联
		start_normal()
		
func handle_file_open(file_path):
	# 验证路径是否存在且是文件
	if FileAccess.file_exists(file_path):
		print("正在打开文件: ", file_path)
		show_file_content(file_path)
	else:
		print("错误: 文件不存在 - ", file_path)
		start_normal()
		
func show_file_content(file_path):
	var file = FileAccess.open(file_path, FileAccess.READ)
	if file:
		var content = file.get_as_text()
		text_edit.text = content
		current_file_path = file_path
		original_content = content
		is_modified = false
		_update_window_title()
		file.close()
	else:
		print("无法读取文件: ", file_path)
		OS.alert("无法读取文件: " + file_path, "错误")


func start_normal():
	# 正常启动时的逻辑
	print("正常启动应用程序")
	text_edit.text = ""
	current_file_path = ""
	original_content = ""
	is_modified = false
	_update_window_title()


func _music_play():
	if Global.music_play == true and is_music == true:
		if not bgm.playing:
			bgm.play()
	else:
		if bgm.playing:
			bgm.stop()

func _minimap():
	if Global.minimap == true:
		text_edit.minimap_draw = true
	else:
		text_edit.minimap_draw = false

func _process(_delta: float) -> void:
	_minimap()
	_show_color()
	_music_play()
	color_rect.color = Global.main_color
	match Global.mode:
		"txt": 
			file_name = "未命名.txt"
			show_mode.text = Global.mode
		"html": 
			file_name = "未命名.html"
			show_mode.text = Global.mode
		"markdown": 
			file_name = "未命名.md"
			show_mode.text = Global.mode


func _on_quit_canceled():
	# 直接退出，不保存
	quit_confirmation.hide()
	get_tree().quit()
	

func _on_text_changed():
	if not is_modified:
		is_modified = true
		_update_window_title()


func _update_window_title():
	var title = "文本编辑器"
	if current_file_path != "":
		title += " - " + current_file_path.get_file()
	if is_modified:
		title += " *"
	get_window().title = title

func _on_files_item_selected(id: int):
	match id:
		0: 
			_check_unsaved_changes(func(): open_dialog.popup_centered_ratio(0.8))
		1: 
			_save_file()
		2: 
			save_dialog.current_file = file_name
			save_dialog.popup_centered_ratio(0.8)
		3:
			_quit_application()
		4:
			_return_to_main_menu()

func _show_color():
	if Global.is_dark:
		show_mode.modulate = Color(1.0, 1.0, 1.0, 0.635)
		mouse_path.modulate = Color(1.0, 1.0, 1.0, 0.635)
	else:
		show_mode.modulate = Color(0.0, 0.0, 0.0, 0.459)
		mouse_path.modulate = Color(0.0, 0.0, 0.0, 0.459)

func _on_ok_pressed():
	get_tree().change_scene_to_file("res://Scene/main/main_ui.tscn")

func _on_cancel_pressed():
	return_main.hide()
	return_main.process_mode = Node.PROCESS_MODE_DISABLED

func _return_to_main_menu():
	return_main.show()
	return_main.process_mode = Node.PROCESS_MODE_INHERIT
	

func _on_return_confirmed(confirm: ConfirmationDialog):
	var pressed_button = confirm.get_ok_button().text
	match pressed_button:
		"OK":
			if current_file_path == "":
				save_dialog.current_file = file_name
				save_dialog.popup_centered_ratio(0.8)
				save_dialog.file_selected.connect(_return_after_save, CONNECT_ONE_SHOT)
			else:
				_save_to_file(current_file_path)
				get_tree().change_scene_to_file("res://Scene/main/main_ui.tscn")
		"Cancel":
			get_tree().change_scene_to_file("res://Scene/main/main_ui.tscn")
		#"不保存直接返回"：
	confirm.queue_free()


func _return_after_save(path: String):
	_save_to_file(path)
	get_tree().change_scene_to_file("res://Scene/main/main_ui.tscn")


func _on_quit_confirmed():
	if current_file_path == "":
		save_dialog.current_file = file_name
		save_dialog.popup_centered_ratio(0.8)
		save_dialog.file_selected.connect(_quit_after_save, CONNECT_ONE_SHOT)
	else:
		_save_to_file(current_file_path)
		get_tree().quit()

func _quit_after_save(path: String):
	_save_to_file(path)
	get_tree().quit()

func _on_open_dialog_selected(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		current_file_path = path
		original_content = file.get_as_text()
		text_edit.text = original_content
		file.close()
		is_modified = false
		_update_window_title()
		print("文件加载成功: ", path)
	else:
		printerr("无法打开文件: ", path)
		OS.alert("无法打开文件: " + path, "错误")

func _on_save_dialog_selected(path: String):
	current_file_path = path
	_save_to_file(path)

func _save_file():
	if current_file_path == "":
		save_dialog.current_file = file_name
		save_dialog.popup_centered_ratio(0.8)
	else:
		_save_to_file(current_file_path)

func _save_to_file(path: String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	if file:
		file.store_string(text_edit.text)
		file.close()
		original_content = text_edit.text
		is_modified = false
		_update_window_title()
		print("文件保存成功: ", path)
	else:
		printerr("保存文件失败: ", path)
		OS.alert("保存文件失败: " + path, "错误")

func _check_unsaved_changes(action: Callable):
	if is_modified:
		var confirm = ConfirmationDialog.new()
		confirm.confirmed.connect(action)
		confirm.confirmed.connect(func(): confirm.queue_free())
		confirm.canceled.connect(func(): confirm.queue_free())
		add_child(confirm)
		confirm.popup_centered()
	else:
		action.call()


func _on_window_close_requested():
	# 阻止窗口关闭
	#get_viewport().get_window().set_flag(Window.FLAG_BORDERLESS, false)
	if is_modified:
		quit_confirmation.popup_centered()
	else:
		get_tree().quit()

# 修改退出应用函数
func _quit_application():
	if is_modified:
		#quit_confirmation.dialog_text = "当前文件有未保存的更改，是否要保存？"
		quit_confirmation.popup_centered()
	else:
		get_tree().quit()


func _on_music_open_pressed() -> void:
	if is_music == true:
		is_music = false
		print(is_music)
	else:
		is_music = true
		print(is_music)
