extends CanvasLayer

func _process(_delta):
	# display health:
	$health.text = str(data.player_health) + " HP"
	
	# display ability statuses
	if data.can_double_jump:
		$double_jump_text.text = "Double Jump? \n YES"
	else:
		$double_jump_text.text = "Double Jump? \n NO"
	
	if data.dash_timer <= 0:
		$dash_text.text = "Dash? \n YES"
	else:
		$dash_text.text = "Dash? \n NO"
	
	if data.slam_timer <= 0:
		$slam_text.text = "Slam? \n YES"
	else:
		$slam_text.text = "Slam? \n NO"
