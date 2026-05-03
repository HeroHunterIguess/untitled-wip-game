extends CharacterBody2D

# movement related variables
var current_gravity = global.GRAVITY

const SOFT_SPEED_CAP = 420
const JUMP_FORCE = 890
const COYOTE_TIME = 0.085

const DASH_COOLDOWN = 75
const DASH_FORCE = 1000

const SLAM_COOLDOWN = 175
const SLAM_FORCE = 1545
const SLAM_REBOUNCE = 550

const BURST_COOLDOWN = 200

const FREEZE_TIME = 1
var frozen = false

var coyote_timer = 0.0
var holding_jump = false
var moving_right = true
var can_jump = false

# attack/ability related things
var is_attacking = false
var dashing = false
var ground_slam = null


func take_dmg(amount):
	if !dashing && !data.slamming:
		data.player_health -= amount
		# hurt sfx/animations here:

func take_kb(force, is_right):
	if is_right:
		velocity.x += force
	elif !is_right:
		velocity.x -= force

	# maybe change this to be player specific kb or a func parameter
	velocity.y -= global.VERTICAL_KNOCKBACK


# updating movement and physics every frame
func _physics_process(delta: float) -> void:
	
	# update cooldowns/timers
	data.dash_timer -= 1
	data.slam_timer -= 1
	data.burst_timer -= 1
	
	# apply gravity
	velocity.y += current_gravity * delta 
	if velocity.y > global.TERMINAL_VELOCITY:
		velocity.y = global.TERMINAL_VELOCITY
	
	if !frozen && !data.slamming:
		# movement directions
		if Input.is_action_pressed("left"):
			velocity.x = move_toward(velocity.x, -SOFT_SPEED_CAP, global.FRICTION * delta)
			moving_right = false
		
		elif Input.is_action_pressed("right"):
			velocity.x = move_toward(velocity.x, SOFT_SPEED_CAP, global.FRICTION * delta)
			moving_right = true
		
		# slow down player when there are no inputs
		else:
			velocity.x = move_toward(velocity.x, 0, global.FRICTION * delta)
		
		# dash in direction last pressed
		if Input.is_action_just_pressed("dash") && data.dash_timer <= 0.0 && data.has_dash: 
			data.dash_timer = DASH_COOLDOWN
			dashing = true
			if moving_right:
				velocity.x += DASH_FORCE
			elif !moving_right:
				velocity.x -= DASH_FORCE
			await get_tree().create_timer(0.25).timeout
			dashing = false
		
	# double/triple jumping
	if Input.is_action_just_pressed("double jump") && !data.slamming:
		if !is_on_floor() && data.double_jumps > 0:
			# if frozen then unfreeze
			if frozen:
				frozen = false
				current_gravity = global.GRAVITY
			
			# apply jump 
			velocity.y = -JUMP_FORCE
			data.double_jumps -= 1
		
		
	# air freeze
	if Input.is_action_just_pressed("air_freeze") && !is_on_floor() && data.can_freeze:
		frozen = true
		data.can_freeze = false
		velocity.y = 0
		velocity.x = 0
		current_gravity = 0
		
		# give double jump to jump out of it
		if data.double_jumps < 1:
			data.double_jumps = 1
		
		await get_tree().create_timer(FREEZE_TIME).timeout
		frozen = false
		
		current_gravity = global.GRAVITY
	
	# check when ground slam hits ground
	if data.slamming && is_on_floor():
		velocity.y = -SLAM_REBOUNCE
		
		is_attacking = false
		data.slamming = false
		data.slam_timer = SLAM_COOLDOWN
		
		# reset ground slam instance if it exists
		if ground_slam:
			ground_slam.queue_free()
			ground_slam = null
	
	# add coyote time
	if is_on_floor():
		coyote_timer = COYOTE_TIME
		data.double_jumps = data.max_jumps
		
		# reset can_freeze if on ground
		data.can_freeze = true
	else: 
		coyote_timer -= delta
		if coyote_timer < 0:
			coyote_timer = 0.0
	
	if is_on_floor() || coyote_timer > 0:
		can_jump = true
	else:
		can_jump = false
	
	# check if they are jumping & perform it
	if (Input.is_action_pressed("jump")) && can_jump:
		coyote_timer = 0.0
		velocity.y = -JUMP_FORCE
	
	# update position based on velocity
	move_and_slide()


# preloads for different attacks
const melee_preload = preload("res://scenes/attacks/basic_melee.tscn")
const ground_slam_preload = preload("res://scenes/attacks/ground_slam.tscn")
const burst_preload = preload("res://scenes/attacks/player_burst_attack.tscn")

# main inputs and attacks
func _process(_delta):
	
	# camera control:
	get_parent().get_node("Camera2D").global_position.x = self.global_position.x
	
	# lock camera at screen edges
	if (get_viewport_rect().size.x / 2) + self.global_position.x > 5000:
		get_parent().get_node("Camera2D").global_position.x = 5000 - get_viewport_rect().size.x / 2
	if self.global_position.x - (get_viewport_rect().size.x / 2) < 0:
		get_parent().get_node("Camera2D").global_position.x = get_viewport_rect().size.x / 2

	
	# check if player dies
	if data.player_health <= 0:
		print("Player Died.")
		get_tree().change_scene_to_file("res://scenes/menus/death_screen.tscn")
	# keep max hp at 100
	if data.player_health > 100:
		data.player_health = 100 
	
	
	# ATTACKS IN DIFFERENT SLOTS
	
	# spawn melee attack
	if Input.is_action_just_pressed("melee_slot"):
		
		# spawn basic melee attack
		if data.melee_slot == "basic" && !is_attacking && !data.slamming:
			var melee_attack = melee_preload.instantiate()
			
			is_attacking = true
			
			add_child(melee_attack)
			
			# spawn on correct side of player
			if get_local_mouse_position().x >= 0:
				melee_attack.global_position = Vector2(self.global_position.x + 35, self.global_position.y)
			if get_local_mouse_position().x < 0:
				melee_attack.global_position = Vector2(self.global_position.x - 35, self.global_position.y)
			
			await get_tree().create_timer(0.25).timeout
			is_attacking = false
			remove_child(melee_attack)
	
	# spawn burst/explosion attack
	
	if Input.is_action_just_pressed("burst_slot"):
		
		# ground slam attack
		if data.burst_slot == "slam" && !is_on_floor() && data.slam_timer <= 0 && !frozen && data.has_ground_slam:
			# spawn hitbox and set positiong
			ground_slam = ground_slam_preload.instantiate()
			add_child(ground_slam)
			data.slamming = true
			
			ground_slam.global_position = Vector2(self.global_position.x, self.global_position.y - 20)
			
			velocity.x = 0
			velocity.y = SLAM_FORCE
		
		# spawn in burst attack
		if data.burst_slot == "burst" && !is_attacking && data.has_burst && data.burst_timer <= 0:
			var burst = burst_preload.instantiate()
			add_child(burst)
			
			data.burst_timer = BURST_COOLDOWN
			is_attacking = true
			
			await get_tree().create_timer(0.08).timeout
			if burst:
				burst.queue_free()
			
			is_attacking = false
