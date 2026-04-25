extends Area2D

const HEALING = 5

func _ready():
	print("i am health pickup and i exist")
	print(self.global_position)

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		data.player_health += HEALING
		print("healing player by 5 hp")
