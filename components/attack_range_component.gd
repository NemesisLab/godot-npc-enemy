class_name AttackRangeComponent extends Node

signal attack_range
signal attack_out_of_range

@export var attack_range_area: Area2D

func _ready() -> void:
	attack_range_area.area_entered.connect(collision)
	attack_range_area.area_exited.connect(out_of_range)

func collision(hurtbox: Area2D) -> void:
	if hurtbox == null or hurtbox.owner == self.owner or hurtbox.name != "HurtBox":
		return
	
	attack_range.emit(self.name)

func out_of_range(hurtbox: Area2D) -> void:
	if hurtbox == null or hurtbox.owner == self.owner or hurtbox.name != "HurtBox":
		return
	
	attack_out_of_range.emit()
