extends Area2D

var damage = 55
var knockback = 1250

func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("player"):
		area.get_parent().take_damage(damage)
		
		if area.to_local(self.global_position).x >= 0:
			area.get_parent().take_kb(knockback, false)
		else: 
			area.get_parent().take_kb(knockback, true)
