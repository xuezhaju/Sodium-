extends FileDialog
@onready var main_font_search: FileDialog = $"."
@onready var line_edit: LineEdit = $"../Settings/VBoxContainer/FontSetting/MainFont/LineEdit"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# 设置打开对话框
	main_font_search.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	main_font_search.add_filter("*.ttf")
	main_font_search.add_filter("*.otf")
	main_font_search.add_filter("*.*;所有文件")
	main_font_search.file_selected.connect(_on_open_dialog_selected)
	main_font_search.hide()
	main_font_search.process_mode = Node.PROCESS_MODE_DISABLED


func _on_open_dialog_selected(path: String):
	var file = FileAccess.open(path, FileAccess.READ)


func _on_line_edit_editing_toggled(toggled_on: bool) -> void:
	line_edit.release_focus()  # 直接释放焦点
	main_font_search.show()
	main_font_search.process_mode = Node.PROCESS_MODE_INHERIT

func _process(delta: float) -> void:
	line_edit.text = Global.main_font

func _on_file_selected(path: String) -> void:
	if Global.is_file_of_type(path, "ttf") or Global.is_file_of_type(path, "otf"):
		Global.main_font = path
		line_edit.text = Global.main_font
	else:
		printerr("font file erro!")
