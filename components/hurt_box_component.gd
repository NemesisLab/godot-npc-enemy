class_name HurtBoxComponent extends Node

signal damage_taken

@export var hurt_box_area: Area2D

func _ready() -> void:
	hurt_box_area.area_entered.connect(collision)

func collision(hitbox: Area2D):
	if hitbox == null or hitbox.name != "HitBox" or hitbox.owner == self.owner:
		return
	
	damage_taken.emit(hitbox.get_damage())
