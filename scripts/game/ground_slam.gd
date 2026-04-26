extends Area2D

const DAMAGE = 55
const KNOCKBACK = 1250

func _on_area_entered(area: Area2D) -> void:
	# damage things in area
	if !area.is_in_group("player"):
		if area.get_parent().has_method("take_damage"):
			area.get_parent().take_damage(DAMAGE)
		
		if area.to_local(self.global_position).x >= 0:
			if area.get_parent().has_method("take_kb"):
				area.get_parent().take_kb(KNOCKBACK, false)
		else: 
			if area.get_parent().has_method("take_kb"):
				area.get_parent().take_kb(KNOCKBACK, true)
	
	# automatically disapear after a short period to prevent weird bugs of it not disapearing
	await get_tree().create_timer(0.75).timeout
	queue_free()
