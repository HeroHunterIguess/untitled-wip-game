extends Area2D

const DAMAGE = 15
const KNOCKBACK = 1175

func _on_area_entered(area: Area2D) -> void:
	# damage things in area
	var object = area.get_parent()
	if object.is_in_group("player"):
		if object.has_method("take_dmg"):
			object.take_dmg(DAMAGE)
		
		if area.to_local(self.global_position).x >= 0:
			if object.has_method("take_kb"):
				object.take_kb(KNOCKBACK, false)
		else: 
			if object.has_method("take_kb"):
				object.take_kb(KNOCKBACK, true)
	
	await get_tree().create_timer(0.15).timeout
	queue_free()
