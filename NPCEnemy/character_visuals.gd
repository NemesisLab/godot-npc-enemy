class_name NPCEnemy extends CharacterBody2D

signal dead

@onready var basic_attack_sprite: Sprite2D = %BasicAttackSprite
@onready var secondary_attack_sprite: Sprite2D = %SecondaryAttackSprite

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var SPEED = 200.0
var current_facing_direction

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()

func chase_enemy(enemy):
	if !enemy:
		return
	
	var enemy_position = enemy.global_position
	face_enemy(enemy_position)
	play_run()
	var direction = global_position.direction_to(Vector2(enemy_position.x, global_position.y))
	velocity = direction * SPEED

func play_attack(attack_name: String, enemy):
	if attack_name == "basic_attack":
		play_basic_attack(enemy)
	if attack_name == "secondary_attack":
		play_secondary_attack(enemy)

func play_basic_attack(enemy):
	if !enemy:
		return
	
	if !%AnimationPlayer2.is_playing():
		face_enemy(enemy.global_position)
	
	switch_to_basic_attack_animation()
	%AnimationPlayer2.play("basic_attack")

func play_secondary_attack(enemy):
	if !enemy:
		return
	
	if !%AnimationPlayer2.is_playing():
		face_enemy(enemy.global_position)
	
	switch_to_secondary_attack_animation()
	%AnimationPlayer2.play("secondary_attack")

func face_enemy(enemy_position):
	var enemy_relative_position = to_local(enemy_position).x < 0
	
	if current_facing_direction == enemy_relative_position:
		return
	
	current_facing_direction = enemy_relative_position
	%AnimationPlayer.flip_h = enemy_relative_position
	basic_attack_sprite.scale.x *= -1
	secondary_attack_sprite.scale.x *= -1

func stop_moving():
	velocity.x = 0

func play_idle():
	switch_to_general_animation()
	%AnimationPlayer.play("idle")

func play_hurt():
	%AnimationPlayer2.stop()
	switch_to_general_animation()
	%AnimationPlayer.play("hurt")

func play_run():
	switch_to_general_animation()
	%AnimationPlayer.play("run")

func play_death():
	switch_to_general_animation()
	%AnimationPlayer.play("death")
	dead.emit()

func stop_animation():
	%AnimationPlayer.stop()
	%AnimationPlayer2.stop()

func switch_to_general_animation():
	basic_attack_sprite.visible = false
	secondary_attack_sprite.visible = false
	%AnimationPlayer.visible = true

func switch_to_basic_attack_animation():
	basic_attack_sprite.visible = true
	secondary_attack_sprite.visible = false
	%AnimationPlayer.visible = false

func switch_to_secondary_attack_animation():
	secondary_attack_sprite.visible = true
	basic_attack_sprite.visible = false
	%AnimationPlayer.visible = false

func get_current_animation():
	return %AnimationPlayer.animation
