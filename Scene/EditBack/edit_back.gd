extends ColorRect

@onready var edit_back: ColorRect = $"."


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.is_dark == "true":
		edit_back.color = Color(0.0, 0.0, 0.0, 0.459)
	elif Global.is_dark == "false":
		edit_back.color = Color(1.0, 1.0, 1.0, 0.635)
	else:
		edit_back.color = Global.back_color
		
