extends Label

# 励志语录数组
var quotes = [
	"成功不是将来才有的，而是从决定去做的那一刻起，持续累积而成。",
	"每一天都是一个新的开始。",
	"不要等待机会，而要创造机会。",
	"相信自己，你能做到比你想象的更多。",
	"困难只是暂时的，放弃才是永久的。",
	"今天的努力，是明天的实力。",
	"行动是治愈恐惧的良药。",
	"失败只是暂时的，除非你放弃。",
	"成功的人不是从不失败，而是从不放弃。",
	"你的态度决定你的高度。",
	"梦想不会逃跑，逃跑的永远是自己。",
	"坚持就是胜利的一半。",
	"没有做不到的事，只有不想做的事。",
	"每一次跌倒都是为了更好的站起来。",
	"生活不是等待暴风雨过去，而是学会在雨中跳舞。",
	"All in Godot"
]

# 字体大小范围
const MIN_FONT_SIZE = 18
const MAX_FONT_SIZE = 36
const BASE_FONT_SIZE = 24

# 切换语录的时间间隔（秒）
var change_interval = 10.0
var timer = 0.0

func _ready():
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	# 显示随机语录
	show_random_quote()

func _process(delta):
	timer += delta
	if timer >= change_interval:
		timer = 0.0
		show_random_quote()

# 显示随机语录并调整字体大小
func show_random_quote():
	var random_index = randi() % quotes.size()
	text = quotes[random_index]
	adjust_font_size()

# 根据文本长度调整字体大小
func adjust_font_size():
	# 计算文本长度（考虑换行符的影响）
	var text_length = text.replace("\n", "").length()
	
	# 根据文本长度计算字体大小（文本越长，字体越小）
	var calculated_size = BASE_FONT_SIZE * (1.0 - min(0.5, text_length / 100.0))
	
	# 确保字体大小在合理范围内
	var final_size = clamp(calculated_size, MIN_FONT_SIZE, MAX_FONT_SIZE)
	
	# 应用计算后的字体大小
	add_theme_font_size_override("font_size", final_size)
	
	# 调试输出（可选）
	print("Text length: ", text_length, " | Font size: ", final_size)
