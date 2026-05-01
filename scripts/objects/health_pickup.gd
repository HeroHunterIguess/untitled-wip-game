extends Area2D

const HEALING = 5


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		data.player_health += HEALING
		#sfx?
		
		queue_free()

# bob up and down over time
var amplitude = 0.175
var frequency = 4.4
var time = 0.0

func _process(delta):
	time += delta * frequency
	self.global_position.y += (amplitude * sin(time))
