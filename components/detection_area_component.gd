class_name DetectionAreaComponent extends Node

signal detected_body
signal body_exited

@export var detection_area: Area2D

func _ready() -> void:
	detection_area.body_entered.connect(body_collison)
	detection_area.body_exited.connect(body_exit)

func isEnemy(character: CharacterBody2D):
	return true

func body_collison(body: CharacterBody2D):
	if body == null or body == self.owner or body.is_dead():
		return
	
	if isEnemy(body):
		detected_body.emit(body)

func body_exit(body: CharacterBody2D) -> void:
	body_exited.emit()
