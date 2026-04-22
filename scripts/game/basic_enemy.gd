extends CharacterBody2D

const JUMP_FORCE = 550
const SOFT_SPEED_CAP = 325
const DAMAGE = 8

var health = 100
var rng = RandomNumberGenerator.new()

func take_damage(amount):
	health -= amount
	print(health)
	# hurt anim or sfx?

func take_kb(force, is_right):
	if is_right:
		velocity.x += force
	elif !is_right:
		velocity.x -= force
	velocity.y -= global.VERTICAL_KNOCKBACK

# updating movement and physics every frame
func _physics_process(delta: float) -> void:
	
	# move roughly towards player but not fully
	var random_number = rng.randi_range(1,3)
	
	if random_number == 1:
		if get_tree().root.find_child("player",true,false).to_local(self.global_position).x >= 0:
			velocity.x = move_toward(velocity.x, SOFT_SPEED_CAP, global.FRICTION * delta)
		elif get_tree().root.find_child("player",true,false).to_local(self.global_position).x < 0:
			velocity.x = move_toward(velocity.x, -SOFT_SPEED_CAP, global.FRICTION * delta)
	else:
		if get_tree().root.find_child("player",true,false).to_local(self.global_position).x >= 0:
			velocity.x = move_toward(velocity.x, -SOFT_SPEED_CAP, global.FRICTION * delta)
		elif get_tree().root.find_child("player",true,false).to_local(self.global_position).x < 0:
			velocity.x = move_toward(velocity.x, SOFT_SPEED_CAP, global.FRICTION * delta)
	
	# jump if at wall/other enemy
	if is_on_wall() && is_on_floor():
		velocity.y -= JUMP_FORCE
	
	# apply gravity
	velocity.y += global.GRAVITY * delta
	if velocity.y > global.TERMINAL_VELOCITY:
		velocity.y = global.TERMINAL_VELOCITY
	
	# update position based on velocity
	move_and_slide()

func _process(_delta):
	# die if health is 0
	if (health <= 0):
		# anim/sfx?
		queue_free()

# deal damage to player when touched
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().take_damage(DAMAGE)
