class_name NPCEnemy extends CharacterBody2D

signal dead

var GRAVITY = ProjectSettings.get_setting("physics/2d/default_gravity")
var SPEED = 200.0

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

func play_basic_attack(enemy):
	if !enemy:
		return
	
	if !%AnimationPlayer2.is_playing():
		face_enemy(enemy.global_position)
	
	switch_to_attack_animation()
	%AnimationPlayer2.play("basic_attack")

func face_enemy(enemy_position):
	%AnimationPlayer.flip_h = to_local(enemy_position).x < 0
	%Sprite2D.flip_h = to_local(enemy_position).x < 0

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
	%Sprite2D.visible = false
	%AnimationPlayer.visible = true

func switch_to_attack_animation():
	%Sprite2D.visible = true
	%AnimationPlayer.visible = false

func get_current_animation():
	return %AnimationPlayer.animation
