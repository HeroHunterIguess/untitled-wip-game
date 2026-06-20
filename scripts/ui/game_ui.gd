extends CanvasLayer

### extremely minimal ui idc rn ###

func _process(_delta):
	# display health:
	$health.text = str(data.player_health) + " HP"
