# VolumeSlider.gd (附加到HSlider节点)
extends HSlider

func _ready():
	# 初始化滑块范围
	min_value = 0.0
	max_value = 1.0
	step = 0.01
	
	# 加载保存的音量
	value = Global.master_volume_linear
	
	# 连接信号
	value_changed.connect(_on_volume_changed)

func _on_volume_changed(value: float):
	Global.master_volume_linear = value
