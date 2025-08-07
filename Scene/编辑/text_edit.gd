extends TextEdit

@onready var cursor_pos_label: Label = $"../EditBack/MousePath"  # 用于显示光标位置的Label
@onready var text_edit: TextEdit = $"."


func _ready():
	# 正确信号：caret_changed （Godot 4 专用）
	caret_changed.connect(_update_cursor_position)
	# 监听全局设置变化
	Global.code_light_changed.connect(_on_code_light_changed)
	# 确保Global单例已加载
	if not Global.code_light_changed.is_connected(_on_code_light_changed):
		Global.code_light_changed.connect(_on_code_light_changed)
	# 初始化状态
	update_syntax_highlighting()
	

func update_syntax_highlighting():
	# 创建新字体并设置大小
	var font = FontFile.new()
	font.fixed_size = Global.font_size  # 设置字号

	# 应用到 TextEdit
	text_edit.add_theme_font_override("font", font)
	text_edit.add_theme_font_size_override("font_size", Global.font_size)
	
	if Global.code_light:
		enable_syntax_highlighting()
	else:
		disable_syntax_highlighting()


func _code_light():
	if Global.code_light:
		enable_syntax_highlighting()
		print(001)
	else:
		disable_syntax_highlighting()


# 当光标位置变化时调用
func _update_cursor_position():
	var line = get_caret_line() + 1      # 获取当前行号（1-based）
	var column = get_caret_column() + 1  # 获取当前列号（1-based）
	
	# 更新Label显示
	cursor_pos_label.text = "行: %d, 列: %d" % [line, column]


# 启用语法高亮
func enable_syntax_highlighting():
	if text_edit.syntax_highlighter == null:
		# 创建新的高亮器实例
		var highlighter = CodeHighlighter.new()
		_setup_custom_highlighting(highlighter)
		text_edit.syntax_highlighter = highlighter
	print("语法高亮已启用")

# 禁用语法高亮
func disable_syntax_highlighting():
	text_edit.syntax_highlighter = null
	text_edit.modulate = Global.main_font_color
	print("语法高亮已禁用")

func _setup_custom_highlighting(highlighter: CodeHighlighter):
	# 设置GDScript关键字颜色
	if Global.is_dark:
		text_edit.add_theme_color_override("font_color", Color.WHITE)            # 白色正文
		text_edit.add_theme_color_override("symbol_color", Color("#FF00FF"))  # 紫色
	else:
		text_edit.add_theme_color_override("font_color", Color("#1E1E2E"))    # 深色正文
		text_edit.add_theme_color_override("symbol_color", Color("#FF00FF"))  # 紫色
		
	highlighter.keyword_colors = {
		"func": Color("#569CD6"),
		"var": Color("#569CD6"), 
		"if": Color("#C586C0"),
		"else": Color("#C586C0"),
		"for": Color("#C586C0"),
		"while": Color("#C586C0")
	}
	highlighter.function_color = Color("#DCDCAA")
	highlighter.number_color = Color("#B5CEA8")

func _on_code_light_changed(_enabled: bool):
	_code_light()
