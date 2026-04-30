extends CanvasLayer

func _process(_delta):
	# display health:
	$health.text = str(data.player_health) + " HP"
	
	# display ability statuses
	if data.double_jumps > 0:
		$double_jump_text.text = "Double Jump? \n YES"
		$double_jump_text.set("theme_override_colors/font_color", Color(0, 1, 0))
	else:
		$double_jump_text.text = "Double Jump? \n NO"
		$double_jump_text.set("theme_override_colors/font_color", Color(1, 0, 0))
	
	if data.dash_timer <= 0:
		$dash_text.text = "Dash? \n YES"
		$dash_text.set("theme_override_colors/font_color", Color(0, 1, 0))
	else:
		$dash_text.text = "Dash? \n NO"
		$dash_text.set("theme_override_colors/font_color", Color(1, 0, 0))
	
	if data.slam_timer <= 0:
		$slam_text.text = "Slam? \n YES"
		$slam_text.set("theme_override_colors/font_color", Color(0, 1, 0))
	else:
		$slam_text.text = "Slam? \n NO"
		$slam_text.set("theme_override_colors/font_color",  Color(1, 0, 0))
	
	if data.burst_timer <= 0:
		$burst_text.text = "Burst? \n YES"
		$burst_text.set("theme_override_colors/font_color", Color(0, 1, 0))
	else:
		$burst_text.text = "Burst? \n NO"
		$burst_text.set("theme_override_colors/font_color", Color(1, 0, 0))
