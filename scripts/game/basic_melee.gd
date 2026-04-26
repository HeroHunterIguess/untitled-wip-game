extends Area2D

const DAMAGE = 50

func _on_area_entered(area: Area2D) -> void:
	if area.get_parent().has_method("take_damage"):
		area.get_parent().take_damage(DAMAGE)
