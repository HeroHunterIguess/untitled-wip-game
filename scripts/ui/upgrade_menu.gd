extends CanvasLayer

### upgrade paths ###
const melee_upgrades = ["Basic melee", "Long melee"] # long_melee not implimented

const burst_upgrades = ["Burst", "Ground slam", "Super slam"] # super_slam not implimented

const ranged_upgrades = ["Laser gun", "Grenade", "Frag grenade"] # none of these are implimented

const movement_upgrades = ["dash", "double jump", "air freeze", "triple jump"]
const repeating_upgrades = ["Health increase", "Melee damage increase", "Ranged damage increase", "Burst damage increase"]

### general variables ###
var rng = RandomNumberGenerator.new()

var button_1_rng = rng.randi_range(1, 3)
var button_2_rng = rng.randi_range(1, 2)

var repeat_upgrade_option

var start_time = Time.get_unix_time_from_system()


func close():
	data.time_paused += Time.get_unix_time_from_system() - start_time
	get_tree().paused = false
	self.queue_free()

func _ready():
	start_time = Time.get_unix_time_from_system()
	
	get_tree().paused = true
	
	button_1_rng = rng.randi_range(1, 3)
	button_2_rng = rng.randi_range(1, 2)
	if data.current_movement_upgrade >= 4:
		button_2_rng = 2
	
	# set button upgrade labels
	# THESE ARE BE ABLE TO OVERFLOW RIGHT NOW I NEED TO CHECK THIS MORE
	if button_1_rng == 1:
		$upgrade_1.text = "Unlock " + melee_upgrades[data.current_melee_tier+1]
	if button_1_rng == 2:
		$upgrade_1.text = "Unlock " + burst_upgrades[data.current_burst_tier+1]
	if button_1_rng == 3:
		$upgrade_1.text = "Unlock " + ranged_upgrades[data.current_ranged_tier+1]
	if button_2_rng == 1:
		$upgrade_2.text = "Unlock " + movement_upgrades[data.current_movement_upgrade+1] 
	if button_2_rng == 2:
		# make sure it never offers an upgrade for something you havent unlocked
		
		# THIS IS NOT FULLY IMPLIMENTED PLEASE FIX 
		if data.current_ranged_tier > -1 and data.current_burst_tier > -1:
			repeat_upgrade_option = rng.randi_range(0, len(repeating_upgrades) - 1)
		elif data.current_ranged_tier > -1 and data.current_burst_tier == -1:
			repeat_upgrade_option = rng.randi_range(0, len(repeating_upgrades) - 2)
		else:
			repeat_upgrade_option = rng.randi_range(0, len(repeating_upgrades) - 3)
		$upgrade_2.text = repeating_upgrades[repeat_upgrade_option]


### get upgrades ###
func _on_upgrade_1_button_down() -> void:
	# chose upgrade path
	
	if button_1_rng == 1: # melee upgrades
		data.melee_slot = melee_upgrades[data.current_melee_tier+1]
		data.current_melee_tier += 1
	elif button_1_rng == 2: # burst upgrades
		data.burst_slot = burst_upgrades[data.current_burst_tier+1]
		data.current_burst_tier += 1
	elif button_1_rng == 3: # ranged upgrades
		data.range_slot = ranged_upgrades[data.current_ranged_tier+1]
		data.current_ranged_tier += 1
	
	close()

func _on_upgrade_2_button_down() -> void:
	# chose buff upgrade path
	
	if button_2_rng == 1:
		data.current_movement_upgrade += 1
		# unlock current movement upgrade
		if data.current_movement_upgrade == 0:
			data.has_dash = true
		elif data.current_movement_upgrade == 1 or data.current_movement_upgrade == 3:
			data.max_jumps += 1
		elif data.current_movement_upgrade == 2:
			data.has_freeze = true
	
	# reoccuring upgrades
	
	if button_2_rng == 2: 
		if repeating_upgrades[repeat_upgrade_option] == "Health increase":
			data.max_health += 2
			data.player_health += 2
		elif repeating_upgrades[repeat_upgrade_option] == "Melee damage increase":
			data.melee_damage_increase += 4
		elif repeating_upgrades[repeat_upgrade_option] == "Ranged damage increase":
			data.ranged_damage_increase += 4
		elif repeating_upgrades[repeat_upgrade_option] == "Burst damage increase":
			data.burst_damage_increase += 4
	
	close()
