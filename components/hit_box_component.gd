class_name HitBoxComponent extends Node

signal hit

@export var hit_box_area: Area2D

func _ready() -> void:
	hit_box_area.area_entered.connect(collision)

func collision(hurtbox: Area2D):
	if hurtbox == null or hurtbox.name != "HurtBox":
		return
	
	if owner.has_method("get_damage"):
		hit.emit()
