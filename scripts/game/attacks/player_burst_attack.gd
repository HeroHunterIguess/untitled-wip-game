extends Area2D

const DAMAGE = 60
const KNOCKBACK = 1395

const SCALE_SPEED = 0.02

func _on_area_entered(area: Area2D) -> void:
	# damage things in area
	var object = area.get_parent()
	if !object.is_in_group("player"):
		if object.has_method("take_damage"):
			object.health = object.take_damage(object.health, DAMAGE)
		
		if area.to_local(self.global_position).x >= 0:
			if object.has_method("take_kb"):
				object.take_kb(KNOCKBACK, false)
		else: 
			if object.has_method("take_kb"):
				object.take_kb(KNOCKBACK, true)
	
	await get_tree().create_timer(0.08).timeout
	queue_free()

# scale up explosion quickly
func _process(_delta):
	$Explosion.scale += Vector2(SCALE_SPEED, SCALE_SPEED)
