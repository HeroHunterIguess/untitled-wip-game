extends Area2D

const DAMAGE = 8
const KNOCKBACK = 1050

# lock burst in initial position
var initial_position
func _ready():
	initial_position = self.global_position

func _process(_delta):
	self.global_position = initial_position
	
	# scale up explosion sprite
	$Explosion.scale += Vector2(global.SCALE_SPEED, global.SCALE_SPEED)

func _on_area_entered(area: Area2D) -> void:
	# damage things in area
	var object = area.get_parent()
	if object.is_in_group("player") && not data.slamming:
		if object.has_method("take_dmg"):
			object.take_dmg(DAMAGE)
		
		if area.to_local(self.global_position).x >= 0:
			if object.has_method("take_kb"):
				object.take_kb(KNOCKBACK, false)
		else: 
			if object.has_method("take_kb"):
				object.take_kb(KNOCKBACK, true)
	
	await get_tree().create_timer(0.08).timeout
	self.queue_free()
