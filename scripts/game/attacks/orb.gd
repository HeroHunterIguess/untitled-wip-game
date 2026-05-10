extends "res://scripts/autoloads/attack_methods.gd"

const DAMAGE = 25
const KNOCKBACK = 250
const COOLDOWN = 0.45

var checking = true

func _process(_delta):
	await get_tree().create_timer(COOLDOWN).timeout
	
	checking = true

func _on_area_entered(area: Area2D) -> void:
	deal_damage(area, DAMAGE, KNOCKBACK)
	checking = false
