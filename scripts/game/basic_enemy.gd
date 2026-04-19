extends CharacterBody2D

const SOFT_SPEED_CAP = 375

var health = 100
var rng = RandomNumberGenerator.new()

func take_damage(amount):
	health -= amount
	print(health)
	# hurt anim or sfx?

# updating movement and physics every frame
func _physics_process(delta: float) -> void:
	
	# move random direction
	var random_number = rng.randi_range(1,2)
	if random_number == 1:
		velocity.x = move_toward(velocity.x, -SOFT_SPEED_CAP, global.FRICTION * delta)
	else:
		velocity.x = move_toward(velocity.x, SOFT_SPEED_CAP, global.FRICTION * delta)
	
	# apply gravity
	velocity.y += global.GRAVITY * delta
	if velocity.y > global.TERMINAL_VELOCITY:
		velocity.y = global.TERMINAL_VELOCITY
	
	# update position based on velocity
	move_and_slide()
