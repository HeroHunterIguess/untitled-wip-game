extends Area2D

const DAMAGE = 50
const KNOCKBACK = 270

func _on_area_entered(area: Area2D) -> void:
	var object = area.get_parent()
	
	if !object.is_in_group("player") && !area.is_in_group("range_detection"):
		# deal damage to the enemy
		if object.has_method("take_damage"):
			object.health = object.take_damage(object.health, DAMAGE)
		
		# knock enemy back
		if object.has_method("take_kb"):
			
			if object.to_local(self.global_position).x >= 0:
				object.take_kb(KNOCKBACK, false)
			else:
				object.take_kb(KNOCKBACK, true)

func _process(_delta):
	if get_tree().root.find_child("player",true,false).to_local(self.global_position).x >= 0:
		$Attack.global_position.x += 0.8
		$CollisionShape2D.global_position.x += 0.8
	else:
		$Attack.global_position.x -= 0.8
		$CollisionShape2D.global_position.x -= 0.8
