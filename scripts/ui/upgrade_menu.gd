extends CanvasLayer

### upgrade paths ###
const melee_upgrades = ["Basic melee", "Long melee"] # long_melee not implimented
var current_melee_tier = 0

const burst_upgrades = ["Burst", "Ground slam", "Super slam"] # super_slam not implimented
var current_burst_tier = -1 # -1 means start with nothing

const ranged_upgrades = ["Laser gun", "Grenade", "Frag grenade"] # none of these are implimented
var current_ranged_tier = -1 # -1 means start with nothing

const movement_upgrades = ["dash", "double jump", "air freeze", "triple jump"]
var current_movement_upgrade = -1 # -1 means start with nothing
const repeating_upgrades = ["Health increase", "Melee damage increase", "Ranged damage increase", "Burst damage increase"] # none of these are implimented

### general variables ###
var rng = RandomNumberGenerator.new()

var button_1_rng = rng.randi_range(1, 3)
var button_2_rng = rng.randi_range(1, 2)

var start_time = Time.get_unix_time_from_system()


func close():
	data.time_paused = Time.get_unix_time_from_system() - start_time
	get_tree().paused = false
	self.queue_free()

func _ready():
	start_time = Time.get_unix_time_from_system()
	
	get_tree().paused = true
	
	button_1_rng = rng.randi_range(1, 3)
	button_2_rng = rng.randi_range(1, 2)
	if current_movement_upgrade >= 4:
		button_2_rng = 2
	
	# set button upgrade labels
	if button_1_rng == 1:
		$upgrade_1.text = "Unlock " + melee_upgrades[current_melee_tier+1]
	if button_1_rng == 2:
		$upgrade_1.text = "Unlock " + burst_upgrades[current_burst_tier+1]
	if button_1_rng == 3:
		$upgrade_1.text = "Unlock " + ranged_upgrades[current_ranged_tier+1]
	
	if button_2_rng == 1:
		$upgrade_2.text = "Unlock " + movement_upgrades[current_movement_upgrade+1]
	if button_2_rng == 2:
		$upgrade_2.text = repeating_upgrades[rng.randi_range(0, len(repeating_upgrades) - 1)]


### get upgrades ###
func _on_upgrade_1_button_down() -> void:
	# chose upgrade path
	
	if button_1_rng == 1: # melee upgrades
		data.melee_slot = melee_upgrades[current_melee_tier+1]
		current_melee_tier += 1
	elif button_1_rng == 2: # burst upgrades
		data.burst_slot = burst_upgrades[current_burst_tier+1]
		current_burst_tier += 1
	elif button_1_rng == 3: # ranged upgrades
		data.range_slot = ranged_upgrades[current_ranged_tier+1]
		current_ranged_tier += 1
	
	close()

func _on_upgrade_2_button_down() -> void:
	# chose buff upgrade path
	
	if button_2_rng == 1:
		current_movement_upgrade += 1
		# unlock current movement upgrade
		if current_movement_upgrade == 0:
			data.has_dash = true
		elif current_movement_upgrade == 1 or current_movement_upgrade == 3:
			data.max_jumps += 1
		# add thing to unlock freeze bc rn you always have it
	
	close()
