extends CanvasLayer

### upgrade paths ###
const melee_upgrades = ["Basic", "Long"] # long_melee not implimented
var current_melee_tier = 0

const burst_upgrades = ["Burst", "Ground slam", "Super slam"] # super_slam not implimented
var current_burst_tier = -1 # -1 means start with nothing

const ranged_upgrades = ["Laser gun", "Grenade", "Frag grenade"] # none of these are implimented
var current_ranged_tier = -1 # -1 means start with nothing

const movement_upgrades = ["dash", "double jump", "air freeze", "triple jump"]
var current_movement_upgrade = -1 # -1 means start with nothing
const repeating_upgrades = ["Health increase", "Melee damage increase", "Ranged damage increase", "Burst damage increase"] # none of these are implimented

var rng = RandomNumberGenerator.new()
var button_1_rng = rng.randi_range(1, 3)
var button_2_rng = rng.randi_range(1, 2)

func close():
	get_tree().paused = false
	self.queue_free()

func _ready():
	get_tree().paused = true
	
	# set button upgrade labels
	if button_1_rng == 1:
		$upgrade_1.text = melee_upgrades[current_melee_tier] + " melee"
	if button_1_rng == 2:
		$upgrade_1.text = "Unlock " + burst_upgrades[current_burst_tier]
	if button_1_rng == 3:
		$upgrade_1.text = "Unlock " + ranged_upgrades[current_ranged_tier]
	
	if button_2_rng == 1:
		$upgrade_2.text = "Unlock " + movement_upgrades[current_movement_upgrade]
	if button_2_rng == 2:
		$upgrade_2.text = repeating_upgrades[rng.randi_range(0, len(repeating_upgrades))]
	


### get upgrades ###
func _on_upgrade_1_button_down() -> void:
	# chose random upgrade path
	
	if button_1_rng == 1: # melee 
		pass
	
	close()

func _on_upgrade_2_button_down() -> void:
	# chose random buff upgrade path
	
	
	close()
