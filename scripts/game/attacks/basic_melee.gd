extends "res://scripts/autoloads/attack_methods.gd"

# constants
const DAMAGE = 50
const KNOCKBACK = 270
const SPEED = 0.8

func _on_area_entered(area: Area2D) -> void:
	deal_damage(area, DAMAGE, KNOCKBACK)

# move in direction of attack
func _process(_delta):
	if get_tree().root.find_child("player",true,false).to_local(self.global_position).x >= 0:
		$Attack.global_position.x += SPEED
		$CollisionShape2D.global_position.x += SPEED
	else:
		$Attack.global_position.x -= SPEED
		$CollisionShape2D.global_position.x -= SPEED
