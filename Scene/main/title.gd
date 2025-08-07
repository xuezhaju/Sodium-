extends Label

func _process(delta: float) -> void:
	# 使用正确的主题颜色键名 "font_color" 而不是 "title_color"
	self.add_theme_color_override("font_color", Global.title_font_color)
