class_name HealthComponent extends Node

signal died

@export var visual_health: ProgressBar

var health = 20

func take_damage(damage) -> void:
	health -= damage
	visual_health.value = health
	
	if health <= 0:
		died.emit()

func _on_damage_taken(damage):
	take_damage(damage)
