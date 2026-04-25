extends Node2D

var start_time = Time.get_unix_time_from_system()-20
var game_running = true

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
			
			
		
		# wait arbitrary amount of time then spawn more
		await get_tree().create_timer(5).timeout
