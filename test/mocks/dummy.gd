class_name Dummy extends CharacterBody2D

signal died

@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var animation_player: AnimationPlayer = %AnimationPlayer

@export var SPEED = 400
var health = 20
var dead = false

func _ready() -> void:
	hurt_box_component.damage_taken.connect(_on_damage_taken)
	animation_player.animation_finished.connect(_on_animation_player_animation_finished)

func _physics_process(delta):
	if Input.is_action_pressed("attack"):
		attack()
	
	if Input.is_action_pressed("up"):
		velocity.y = -250.0
	
	var input_direction = Input.get_axis("left", "right")
	
	if input_direction:
		velocity.x = input_direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func is_dead():
	return dead

func set_dead():
	dead = true

func set_health(new_health):
	health = new_health

func take_damage(damage):
	health -= damage
	if (health <= 0):
		%AnimatedSprite2D.play('death')
		died.emit()
		dead = true
	else:
		%AnimatedSprite2D.play('hurt')

func attack():
	%Sprite2D.visible = true
	%AnimatedSprite2D.visible = false
	%AnimationPlayer.play("basic_attack")

func _on_damage_taken(damage) -> void:
	take_damage(damage)

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "basic_attack":
		%Sprite2D.visible = false
		%AnimatedSprite2D.visible = true
