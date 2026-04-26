extends CharacterBody2D

# has all the base methods for enemy types etc
var health = 100

func take_damage(amount):
	health -= amount
	# hurt anim or sfx?

func take_kb(force, is_right):
	if is_right:
		velocity.x += force
	elif !is_right:
		velocity.x -= force
	velocity.y -= global.VERTICAL_KNOCKBACK

# necessary variables for die funciton
var rng = RandomNumberGenerator.new()
const health_pickup_preload = preload("res://scenes/objects/health_pickup.tscn")

# kill enemy and maybe drop pickups
func die():
	# sometimes drop health pickup
	var random_number = rng.randi_range(1, 3)
	
	if random_number == 1:
		var health_pickup = health_pickup_preload.instantiate()
		health_pickup.global_position = self.global_position
		get_parent().add_child(health_pickup)
	
	queue_free()
