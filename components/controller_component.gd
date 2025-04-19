extends Node

class_name ControllerComponent

@onready var character: CharacterBody2D = $".."
@onready var hurt_box_component: HurtBoxComponent = %HurtBoxComponent
@onready var health_component: HealthComponent = %HealthComponent
@onready var detection_area_component: DetectionAreaComponent = %DetectionAreaComponent
@onready var attack_range_component: AttackRangeComponent = %AttackRangeComponent

enum State {IDLE, CHASING, HURT, ATTACKING, DYING, DEAD}
var current_state: State = State.IDLE
var selected_target
var out_of_attack_range = true
var out_of_detection_range = true
var character_dead = false

func _ready() -> void:
	detection_area_component.detected_body.connect(_on_detected_body)
	detection_area_component.body_exited.connect(_on_detected_body_exited)
	attack_range_component.attack_range.connect(_on_attack_range)
	attack_range_component.attack_out_of_range.connect(_on_attack_out_of_range_range)
	hurt_box_component.damage_taken.connect(_on_hurtbox_damage_taken)
	hurt_box_component.damage_taken.connect(health_component._on_health_damage_taken)
	health_component.died.connect(_on_death)
	%AnimationPlayer.animation_finished.connect(_on_animation_player_animation_finished)
	%AnimationPlayer2.animation_finished.connect(_on_animation_player_2_animation_finished)

func _process(delta: float) -> void:
	if character_dead:
		return
	
	match current_state:
		State.IDLE:
			character.play_idle()
		State.CHASING:
			character.chase_enemy(selected_target)
		State.HURT:
			character.play_hurt()
		State.ATTACKING:
			character.play_basic_attack(selected_target)
		State.DYING:
			character.play_death()
			set_process(false)
		State.DEAD:
			character_dead = true

func evaluate_state():
	if !out_of_attack_range:
		current_state = State.ATTACKING
	if out_of_attack_range && !out_of_detection_range:
		current_state = State.CHASING
	
	if current_state == State.DYING:
		current_state = State.DEAD

func _on_hurtbox_damage_taken(damage) -> void:
	character.stop_animation()
	current_state = State.HURT

func _on_attack_range() -> void:
	out_of_attack_range = false
	character.stop_moving()
	current_state = State.ATTACKING

func _on_attack_out_of_range_range():
	out_of_attack_range = true

func _on_detected_body(character_detected: CharacterBody2D) -> void:
	out_of_detection_range = false
	selected_target = character_detected
	current_state = State.CHASING
	if selected_target.has_signal("died"):
		selected_target.connect("died", func(): selected_target = null)

func _on_detected_body_exited() -> void:
	out_of_detection_range = true
	selected_target = null
	character.stop_moving()
	current_state = State.IDLE

func _on_death() -> void:
	current_state = State.DYING

func _on_animation_player_animation_finished() -> void:
	evaluate_state()

func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	evaluate_state()
			
