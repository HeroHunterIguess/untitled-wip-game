extends Node2D

var start_time = Time.get_unix_time_from_system() - 20
var game_running = true
var round_bonus_time = 0

var rng = RandomNumberGenerator.new()

const enemy_preload = preload("res://scenes/enemy_types/basic_enemy.tscn")
const burst_enemy_preload = preload("res://scenes/enemy_types/burst_enemy.tscn")

func set_location(object):
	var screen_width = get_viewport().size.x
	var left_location = $player.global_position.x-screen_width - 100
	var right_location = $player.global_position.x+screen_width + 100
	
	# spawn enemy off screen and vary random distance to have minimal overlap bugs
	
	# i need to save the location of the last one so i can vary it to ensure they never have the overlap speed bug
	if left_location < 0:
		object.global_position.x = right_location + rng.randi_range(0, 99)
	if right_location > 4000:
		object.global_position.x = left_location - rng.randi_range(0, 99)
	
	# set y to a value close to ground
	object.global_position.y = 500

func _ready():
	while game_running:
		# spawn enemies based on time elapsed
		var amount = (Time.get_unix_time_from_system() - start_time) / 10
		var burst_amount = (Time.get_unix_time_from_system() - start_time) / 20
		
		# spawn basic enemies
		for i in range(amount):
			var enemy = enemy_preload.instantiate()
			add_child(enemy) 
			
			set_location(enemy)
		
		# spawn burst enemies
		for i in range(burst_amount):
			var burst_enemy = burst_enemy_preload.instantiate()
			add_child(burst_enemy)
			
			set_location(burst_enemy)
		
		# wait arbitrary amount of time then spawn more
		await get_tree().create_timer(5 + round_bonus_time).timeout
		
		# add extra time for each round bc there will be more enemies
		round_bonus_time += 0.95
