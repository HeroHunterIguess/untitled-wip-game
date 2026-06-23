extends "res://scripts/autoloads/enemy_methods.gd"

const JUMP_FORCE = 550
const SOFT_SPEED_CAP = 290
const BURST_COOLDOWN = 250

var burst_timer = 0.0
var health = 150

const DAMAGE = 2 # low damage bc it has an ability

### update physics and movement ###
func _physics_process(delta: float) -> void:
	# move roughly towards player but not fully
	enemy_methods.movement(self, 4, SOFT_SPEED_CAP, delta, JUMP_FORCE)

# check for death every frame
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
	if burst_timer <= 0 && area.is_in_group("player") && !data.slamming && health > 0:
		burst_timer = BURST_COOLDOWN
		
		# only actually burst if dashing ... but still reset timer either way
		if !data.dashing:
			var burst = burst_preload.instantiate()
			
			add_child(burst)
			get_tree().get_current_scene().get_node("explosion_sfx") # doesnt work
			burst.global_position = self.global_position
