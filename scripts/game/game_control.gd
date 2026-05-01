extends Node2D

var start_time = Time.get_unix_time_from_system() - 20
var game_running = true
var round_bonus_time = 0
var offset = 0

const enemy_preload = preload("res://scenes/enemy_types/basic_enemy.tscn")
const burst_enemy_preload = preload("res://scenes/enemy_types/burst_enemy.tscn")


func set_location(object):
	var screen_width = get_viewport().size.x
	var left_location = $Camera2D.global_position.x - (screen_width / 2 - 250)
	var right_location = $Camera2D.global_position.x + (screen_width / 2 + 250)
	
	# spawn enemy off screen and vary distance to prevent overlap bugs
	if left_location <= 0:
		var location = right_location + offset
		offset += 1
		
		object.global_position.x = location
	elif right_location >= 5000:
		var location = left_location - offset
		offset += 1
		
		object.global_position.x = location
	else:
		var location = right_location - offset
		offset += 1
		
		object.global_position.x = location
	
	if offset >= 100:
		offset = 0
	
	# set y to a value close to ground
	object.global_position.y = 530


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
		await get_tree().create_timer(4 + round_bonus_time).timeout
		
		# add extra time for each round bc there will be more enemies
		round_bonus_time += 0.9
