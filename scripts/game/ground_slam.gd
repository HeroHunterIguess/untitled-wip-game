extends Area2D

const DAMAGE = 55
const KNOCKBACK = 1250

func _on_area_entered(area: Area2D) -> void:
	if !area.is_in_group("player"):
		area.get_parent().take_damage(DAMAGE)
		
		if area.to_local(self.global_position).x >= 0:
			area.get_parent().take_kb(KNOCKBACK, false)
		else: 
			area.get_parent().take_kb(KNOCKBACK, true)
