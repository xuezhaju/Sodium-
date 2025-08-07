extends HSlider

@export var target_label: Label  # 通过编辑器拖拽关联的目标Label节点
@export var min_font_size: int = 8  # 最小字号
@export var max_font_size: int = 72  # 最大字号

func _ready() -> void:
	# 初始化滑块范围
	min_value = min_font_size
	max_value = max_font_size
	
	# 如果没有手动设置目标标签，尝试自动查找
	if target_label == null:
		target_label = get_parent().find_child("Label") as Label
	
	# 连接值改变信号
	value_changed.connect(_on_value_changed)
	
	# 设置初始值 - 优先使用Global.font_size，其次使用标签当前字号，最后使用中间值
	if has_node("/root/Global"):
		value = Global.font_size
	elif target_label:
		value = target_label.get_theme_font_size("font_size")
		Global.font_size = int(value)  # 同步到Global
	else:
		value = (min_font_size + max_font_size) / 2
		Global.font_size = int(value)  # 同步到Global
	
	# 确保目标标签使用当前字号
	if target_label:
		target_label.add_theme_font_size_override("font_size", Global.font_size)

# 当滑块值改变时调用
func _on_value_changed(new_value: float) -> void:
	if target_label:
		target_label.add_theme_font_size_override("font_size", int(new_value))
	
	Global.font_size = int(new_value)
	print("当前字号: ", int(new_value))
