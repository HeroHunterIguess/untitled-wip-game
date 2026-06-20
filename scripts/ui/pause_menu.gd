extends CanvasLayer

func _process(_d):
	# close pause menu
	if Input.is_action_just_pressed("pause"):
		pass


func _on_resume_button_pressed() -> void:
	get_tree().paused = false
