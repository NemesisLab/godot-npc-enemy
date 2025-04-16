extends CharacterBody2D

signal died

@export var speed = 400
@onready var hurt_box_component: HurtBoxComponent = $HurtBoxComponent
@onready var health_component: HealthComponent = $HealthComponent

enum State {IDLE, RUNNING, HURT, ATTACKING, DYING, DEAD}
var current_state: State = State.IDLE
var previous_state: State = State.IDLE
var selected_target
var basic_damage = 10

func _ready() -> void:
	hurt_box_component.damage_taken.connect(_on_playable_character_damage_taken)

func _process(delta: float) -> void:
	if current_state == State.DEAD:
		return
	
	if Input.is_action_pressed("attack"):
		current_state = State.ATTACKING
	
	match current_state:
		State.IDLE:
			play_idle()
		State.RUNNING:
			play_run()
		State.HURT:
			play_hurt()
		State.ATTACKING:
			play_basic_attack()
		State.DYING:
			play_death()

func get_direction_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()

func _physics_process(delta):
	if is_dead():
		return
		
	if Input.is_action_pressed("attack"):
		play_basic_attack()
	
	get_direction_input()

func basic_attack():
	return basic_damage;

func is_dead():
	return current_state == State.DEAD or current_state == State.DYING

func _on_playable_character_damage_taken(damage) -> void:
	previous_state = State.IDLE
	current_state = State.HURT
	health_component.take_damage(damage)

func _on_died() -> void:
	current_state = State.DYING
	died.emit()

func _on_animation_player_animation_finished() -> void:
	var anim_name = get_current_animation()
	if current_state == State.HURT and anim_name == "hurt":
		current_state = previous_state
	if current_state == State.DYING and anim_name == "death":
		current_state = State.DEAD

func _on_animation_attack_player_animation_finished(anim_name: StringName) -> void:
	if current_state == State.ATTACKING and anim_name == "basic_attack":
		current_state = previous_state
		%AttackSprite.visible = false
		%AnimationPlayer.visible = true

func play_basic_attack():
	%AttackSprite.visible = true
	%AnimationPlayer.visible = false
	%AnimationPlayer2.play("basic_attack")

func play_idle():
	%AnimationPlayer.play("idle")

func play_hurt():
	%AnimationPlayer2.stop()
	%AttackSprite.visible = false
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
