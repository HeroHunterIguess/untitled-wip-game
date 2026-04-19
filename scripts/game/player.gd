extends CharacterBody2D

# movement related variables
const SOFT_SPEED_CAP = 420
const JUMP_FORCE = 890
const COYOTE_TIME = 0.085
const DASH_COOLDOWN = 100
const DASH_FORCE = 1000

var coyote_timer = 0.0
var holding_jump = false

var moving_right = true
var can_jump = false

var is_attacking = false


# updating movement and physics every frame
func _physics_process(delta: float) -> void:
	
	# update slide timer
	data.dash_timer -= 1
	
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
	
	# slide input
	if Input.is_action_just_pressed("dash"): 
		if data.dash_timer <= 0.0:
			data.dash_timer = DASH_COOLDOWN
			if moving_right:
				velocity.x += DASH_FORCE
			elif !moving_right:
				velocity.x -= DASH_FORCE
	
	# double jumping
	if Input.is_action_just_pressed("double jump"):
		if !is_on_floor() && data.can_double_jump:
			velocity.y = -JUMP_FORCE
			data.can_double_jump = false
	
	# add coyote time
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
	
	# check if they are jumping or buffering & perform it
	if Input.is_action_pressed("jump"):
		holding_jump = true
	else:
		holding_jump = false
	if (Input.is_action_just_pressed("jump") || holding_jump) && can_jump:
		coyote_timer = 0.0
		velocity.y -= JUMP_FORCE
	
	# update position based on velocity
	move_and_slide()


#const tankEnemyPreload = preload("res://scenes/objects/enemy types/tank_enemy.tscn")
#var tankEnemy = tankEnemyPreload.instantiate()
#add_child(tankEnemy)

# preloads for different attacks
const melee_preload = preload("res://scenes/attacks/basic_melee.tscn")

# main inputs and attacks
func _process(_delta):
	
	# spawn melee attack
	if Input.is_action_just_pressed("melee") && !is_attacking:
		var melee_attack = melee_preload.instantiate()
		is_attacking = true
		if moving_right:
			pass
		else:
			pass
		
