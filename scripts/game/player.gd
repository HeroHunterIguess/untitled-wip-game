extends CharacterBody2D

# movement related variables
const SOFT_SPEED_CAP = 420
const JUMP_FORCE = 890
const COYOTE_TIME = 0.085

const DASH_COOLDOWN = 75
const DASH_FORCE = 1000

const SLAM_COOLDOWN = 175
const SLAM_FORCE = 1350
const SLAM_REBOUNCE = 400


var coyote_timer = 0.0
var holding_jump = false
var moving_right = true
var can_jump = false

# attack/ability related things
var is_attacking = false
var slamming = false
var ground_slam = null

func take_damage(amount):
	data.player_health -= amount
	# hurt sfx/animations here:

# updating movement and physics every frame
func _physics_process(delta: float) -> void:
	
	# update cooldowns/timers
	data.dash_timer -= 1
	data.slam_timer -= 1
	
	# apply gravity
	velocity.y += global.GRAVITY * delta
	if velocity.y > global.TERMINAL_VELOCITY:
		velocity.y = global.TERMINAL_VELOCITY
	
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
	if Input.is_action_just_pressed("dash") && data.dash_timer <= 0.0: 
		data.dash_timer = DASH_COOLDOWN
		if moving_right:
			velocity.x += DASH_FORCE
		elif !moving_right:
			velocity.x -= DASH_FORCE
	
	# double jumping
	if Input.is_action_just_pressed("double jump") && !slamming:
		if !is_on_floor() && data.can_double_jump:
			velocity.y = -JUMP_FORCE
			data.can_double_jump = false
	
	# add coyote time
	# unnecessary with the current flat groud, may be changed later
	# if the ground stays flat like it is, remove coyote time code
	if is_on_floor():
		coyote_timer = COYOTE_TIME
		data.can_double_jump = true
	else: 
		coyote_timer -= delta
		if coyote_timer < 0:
			coyote_timer = 0.0
	
	if (is_on_floor() || coyote_timer > 0) || (is_on_wall() && velocity.y >= 0 && !is_on_floor()):
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

# main inputs and attacks
func _process(_delta):
	
	# check if player dies
	if data.player_health <= 0:
		print("Player Died.")
		get_tree().change_scene_to_file("res://scenes/menus/death_screen.tscn")
	
	# spawn melee attack
	if Input.is_action_just_pressed("melee") && !is_attacking:
		var melee_attack = melee_preload.instantiate()
		add_child(melee_attack)
		
		is_attacking = true

		# spawn on correct side of player
		if get_local_mouse_position().x > 0:
			melee_attack.global_position = Vector2(self.global_position.x + 35, self.global_position.y)
		elif get_local_mouse_position().x < 0:
			melee_attack.global_position = Vector2(self.global_position.x - 35, self.global_position.y)
		
		await get_tree().create_timer(0.25).timeout
		is_attacking = false
		remove_child(melee_attack)
	
	# ground slam attack
	if Input.is_action_just_pressed("ground_slam") && !is_attacking && !is_on_floor() && data.slam_timer <= 0:
		# spawn hitbox and set positiong
		ground_slam = ground_slam_preload.instantiate()
		add_child(ground_slam)
		slamming = true
		
		ground_slam.global_position = Vector2(self.global_position.x, self.global_position.y - 20)
		
		velocity.y = SLAM_FORCE
	
	# check when ground slam hits ground
	if slamming && is_on_floor():
		velocity.y = -SLAM_REBOUNCE
		
		is_attacking = false
		slamming = false
		data.slam_timer = SLAM_COOLDOWN
		
		# reset ground slam instance
		ground_slam.queue_free()
		ground_slam = null
