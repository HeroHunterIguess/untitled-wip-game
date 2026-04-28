extends Area2D

const DAMAGE = 55
const KNOCKBACK = 1250

func _on_area_entered(area: Area2D) -> void:
	# damage things in area
	if !area.is_in_group("player"):
		var object = area.get_parent()
		if object.has_method("take_damage"):
			object.health = object.take_damage(object.health, DAMAGE)
		
		if area.to_local(self.global_position).x >= 0:
			if object.has_method("take_kb"):
				object.take_kb(KNOCKBACK, false)
		else: 
			if object.has_method("take_kb"):
				object.take_kb(KNOCKBACK, true)
	
	# automatically disapear after a short period to prevent weird bugs of it not disapearing
	await get_tree().create_timer(0.75).timeout
	queue_free()
