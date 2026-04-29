extends RigidBody2D

var velocity = Vector2(0, 0)
var is_on_floor = false
var hit_something = false

const KNOCKBACK = 1000
const DAMAGE = 60

func _physics_process(delta):
	
	# apply gravity & movement
	velocity.y += global.GRAVITY
	if velocity.y > global.TERMINAL_VELOCITY:
		velocity.y = global.TERMINAL_VELOCITY
	
	move_and_collide(velocity * delta)


func _on_initial_hit_area_entered(_area: Area2D) -> void:
	hit_something = true


# explode when it hits an enemy
func _on_explosion_radius_area_entered(area: Area2D) -> void:
	# UPDATE THIS TO ENSURE ITS NOT CALLING FUNCTIONS ON ANOTHER GRENADE INSTANCE WHICH ERRORS
	if !area.is_in_group("player") && hit_something:
		var object = area.get_parent()
		
		if object.has_method("take_damage"):
			object.health = object.take_damage(object.health, DAMAGE)
		
		if object.has_method("take_kb"):
			if area.to_local(self.global_position).x >= 0:
				object.take_kb(KNOCKBACK, false)
			else: 
				object.take_kb(KNOCKBACK, true)
				
		queue_free()
