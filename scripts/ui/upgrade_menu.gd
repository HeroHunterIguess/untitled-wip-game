extends CanvasLayer

func close():
	get_tree().paused = false
	self.queue_free()

func _ready():
	get_tree().paused = true


### get upgrades ###
func _on_upgrade_1_button_down() -> void:
	
	close()

func _on_upgrade_2_button_down() -> void:
	
	close()
