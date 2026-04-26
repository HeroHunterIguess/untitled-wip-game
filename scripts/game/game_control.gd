extends Node2D

var start_time = Time.get_unix_time_from_system()-20
var game_running = true
var round_bonus_time = 0

var rng = RandomNumberGenerator.new()

const enemy_preload = preload("res://scenes/enemy types/basic_enemy.tscn")

func _ready():
	while game_running:
		# spawn enemies based on time elapsed
		var amount = (Time.get_unix_time_from_system() - start_time) / 10
		
		print(amount)
		
		for i in range(amount):
			var enemy = enemy_preload.instantiate()
			add_child(enemy) 
			var screen_width = get_viewport().size.x
			var left_location = $player.global_position.x-screen_width-100
			var right_location = $player.global_position.x+screen_width+100
			
			# spawn enemy off screen and vary random distance to have minimal overlap bugs
			if left_location < 0:
				enemy.global_position.x = right_location + rng.randi_range(0, 99)
			if right_location > 4000:
				enemy.global_position.x = left_location - rng.randi_range(0, 99)
			
			# set y to a value close to ground
			enemy.global_position.y = 500
		
		# wait arbitrary amount of time then spawn more
		await get_tree().create_timer(5+round_bonus_time).timeout
		
		# add extra time for each round bc there will be more enemies
		round_bonus_time += 0.75
