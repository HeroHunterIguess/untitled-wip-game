extends Area2D

const HEALING = 5

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		data.player_health += HEALING
		print("healing player by 5 hp")
