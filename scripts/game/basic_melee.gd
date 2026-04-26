extends Area2D

const DAMAGE = 50
const KNOCKBACK = 270

func _on_area_entered(area: Area2D) -> void:
	var object = area.get_parent()
	
	# deal damage to the enemy
	if object.has_method("take_damage"):
		object.take_damage(DAMAGE)
	
	# knock enemy back
	if object.has_method("take_kb"):
		
		if object.to_local(self.global_position).x >= 0:
			object.take_kb(KNOCKBACK, false)
		else:
			object.take_kb(KNOCKBACK, true)
