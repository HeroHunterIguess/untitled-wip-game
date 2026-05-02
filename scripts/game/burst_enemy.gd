extends "res://scripts/autoloads/enemy_methods.gd"

const JUMP_FORCE = 550
const SOFT_SPEED_CAP = 290
const BURST_COOLDOWN = 175

var burst_timer = 0.0
var health = 150

# low damage as itll have an ability
const DAMAGE = 2

# updating movement and physics every frame
func _physics_process(delta: float) -> void:
	
	# move roughly towards player but not fully
	var random_number = rng.randi_range(1, 4)
	
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

# update shit every frame
func _process(_delta):
	if (health <= 0):
		die()
	
	burst_timer -= 1

# deal damage to player when touched
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		area.get_parent().take_dmg(DAMAGE)

const burst_preload = preload("res://scenes/attacks/enemy_burst_attack.tscn")

# spawn in burst attack if player is near
func _on_burst_range_area_entered(area: Area2D) -> void:
	if burst_timer <= 0 && area.get_parent().is_in_group("player") && !data.slamming && health > 0:
		burst_timer = BURST_COOLDOWN
		
		var burst = burst_preload.instantiate()
		
		call_deferred("add_child", burst)
		
		burst.global_position = self.global_position
