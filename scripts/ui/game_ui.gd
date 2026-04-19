extends CanvasLayer

func _process(_delta):
	# display ability statuses
	if data.can_double_jump:
		$double_jump_text.text = "Double Jump? \n YES"
	else:
		$double_jump_text.text = "Double Jump? \n NO"
	
	if data.dash_timer <= 0:
		$dash_text.text = "Dash? \n YES"
	else:
		$dash_text.text = "Dash? \n NO"
