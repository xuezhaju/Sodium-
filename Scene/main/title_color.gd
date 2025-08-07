extends ColorPickerButton

# 获取当前选中的颜色
func get_selected_color() -> Color:
	return self.color

# 示例：当颜色改变时打印颜色值
func _ready() -> void:
	self.color = Global.title_font_color
	# 连接颜色改变信号
	self.color_changed.connect(_on_color_changed)

func _on_color_changed(_color: Color) -> void:
	# 你也可以在这里获取颜色
	Global.title_font_color = get_selected_color()
	Global.is_dark = "other"
