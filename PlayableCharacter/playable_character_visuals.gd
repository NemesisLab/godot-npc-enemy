extends CharacterBody2D

func chase_enemy(target_position):
	play_run()
	face_enemy(target_position)
	var direction = global_position.direction_to(target_position)
	velocity = direction * 300.0
	move_and_slide()

func play_basic_attack(enemy_position):
	%Sprite2D.visible = true
	%AnimationPlayer.visible = false
	%Sprite2D.flip_h = enemy_position.x < 0
	%AnimationPlayer2.play("basic_attack")

func face_enemy(enemy_position):
	%AnimationPlayer.flip_h = enemy_position.x < 0

func play_idle():
	%AnimationPlayer.play("idle")

func play_hurt():
	%AnimationPlayer2.stop()
	%Sprite2D.visible = false
	%AnimationPlayer.visible = true
	%AnimationPlayer.play("hurt")

func play_run():
	%AnimationPlayer.play("run")

func play_death():
	%AnimationPlayer.play("death")

func stop_animation():
	%AnimationPlayer.stop()
	%AnimationPlayer2.stop()

func get_current_animation():
	return %AnimationPlayer.animation
