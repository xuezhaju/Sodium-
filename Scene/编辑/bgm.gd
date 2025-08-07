extends AudioStreamPlayer

@onready var bgm: AudioStreamPlayer = self  # 更清晰的self引用

func _ready() -> void:
	if Global.music_path and Global.music_path != "":
		load_and_play_audio(Global.music_path)
	else:
		push_warning("音乐路径为空，请检查Global.music_path")

func load_and_play_audio(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		var mp3_stream = AudioStreamMP3.new()
		mp3_stream.data = file.get_buffer(file.get_length())
		file.close()
		bgm.stream = mp3_stream
		bgm.play()
	else:
		push_error("无法读取文件: " + path)
