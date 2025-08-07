extends FileDialog

@onready var music_search: FileDialog = $"."
@onready var tips: ConfirmationDialog = $"../Tips"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
# 设置打开对话框
	music_search.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	music_search.add_filter("*.mp3")
	music_search.add_filter("*.ogg")
	music_search.add_filter("*.wav")
	music_search.add_filter("*.flac")
	music_search.add_filter("*.*;所有文件")
	music_search.file_selected.connect(_on_open_dialog_selected)
	music_search.hide()
	tips.hide()
	tips.process_mode = Node.PROCESS_MODE_DISABLED

func _on_open_dialog_selected(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	


func _on_file_selected(path: String) -> void:
	if is_file_of_type(path, "ogg") or is_file_of_type(path, "mp3") or is_file_of_type(path, "wav") or is_file_of_type(path, "flag"):
		Global.music_path = path
	else:
		tips.show()
		tips.process_mode = Node.PROCESS_MODE_INHERIT


func is_file_of_type(file_path: String, expected_extension: String) -> bool:
	return file_path.get_extension().to_lower() == expected_extension.to_lower()
