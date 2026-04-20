extends Area2D

var damage = 34

func _on_area_entered(area: Area2D) -> void:
	area.get_parent().take_damage(damage)
