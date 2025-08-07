extends HBoxContainer

@onready var txt: Button = $txt
@onready var html: Button = $html
@onready var markdown: Button = $markdown



func _on_txt_pressed() -> void:
	Global.mode = "txt"
	get_tree().change_scene_to_file("res://Scene/编辑/编辑页面.tscn")


func _on_html_pressed() -> void:
	Global.mode = "html"
	get_tree().change_scene_to_file("res://Scene/编辑/编辑页面.tscn")


func _on_markdown_pressed() -> void:
	Global.mode = "markdown"
	get_tree().change_scene_to_file("res://Scene/编辑/编辑页面.tscn")
