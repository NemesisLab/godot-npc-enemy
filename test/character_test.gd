class_name CharacterTest
extends GdUnitTestSuite
@warning_ignore('return_value_discarded')

const Utils = preload("res://test/_utils.gd")

var runner
var dummy
var enemy
var scene

func before_test():
	runner = scene_runner("res://pit.tscn")
	scene = runner.scene()
	enemy = runner.invoke("find_child", "NPCEnemy")

func test_is_idle_by_default() -> void:
	assert_that(enemy.get_current_animation()).is_equal("idle")

func test_is_detected_when_enemy_in_range() -> void:
	var enemy_detection_area = enemy.get_node("DetectionArea")
	var da_owner = enemy_detection_area.get_shape_owners()[0]
	var RANGE_DISTANCE = -(enemy_detection_area.shape_owner_get_shape(da_owner, 0).radius)
	
	dummy = Utils.create_dummy(-450, 0)
	scene.add_child(dummy)
	
	var current_distance = dummy.position.x - enemy.position.x
	
	while current_distance < RANGE_DISTANCE:
		runner.simulate_key_press(KEY_D)
		await get_tree().process_frame
		await get_tree().process_frame
		
		current_distance = dummy.position.x
	
	assert_that(current_distance >= RANGE_DISTANCE)

func test_enemy_chase_when_in_detection_range() -> void:
	var enemy_detection_area = enemy.get_node("DetectionArea")
	var da_owner = enemy_detection_area.get_shape_owners()[0]
	var RANGE_DISTANCE = -(enemy_detection_area.shape_owner_get_shape(da_owner, 0).radius)
	
	dummy = Utils.create_dummy(RANGE_DISTANCE, 0)
	scene.add_child(dummy)
	
	await await_millis(100)
	
	assert_that(enemy.get_current_animation()).is_equal("run")

func test_enemy_is_not_detected_if_dead() -> void:
	var enemy_detection_area = enemy.get_node("DetectionArea")
	var da_owner = enemy_detection_area.get_shape_owners()[0]
	var RANGE_DISTANCE = -(enemy_detection_area.shape_owner_get_shape(da_owner, 0).radius)
	
	dummy = Utils.create_dead_dummy(RANGE_DISTANCE, 0)
	scene.add_child(dummy)
	
	await await_millis(100)
	
	assert_that(enemy.get_current_animation()).is_equal("idle")

func test_enemy_attack_when_in_attack_range() -> void:
	var enemy_attack_visuals = enemy.get_node("AnimationPlayer2")
	var enemy_attack_range_area = enemy.get_node("AttackRange")
	var ar_owner = enemy_attack_range_area.get_shape_owners()[0]
	var RANGE_DISTANCE = -(enemy_attack_range_area.shape_owner_get_shape(ar_owner, 0).radius)
	
	await await_millis(500)
	
	dummy = Utils.create_dummy(RANGE_DISTANCE, 0)
	scene.add_child(dummy)
	
	await await_millis(100)
	
	assert_str(enemy_attack_visuals.get_current_animation()).is_equal("basic_attack")

func test_enemy_receives_damage_when_attacked() -> void:
	var health_component = enemy.get_node("HealthComponent")
	enemy.get_node("AttackRangeComponent").queue_free()
	
	dummy = Utils.create_dummy(-5, 0)
	scene.add_child(dummy)
	
	dummy.attack()
	
	await await_millis(100)
	
	var dummy_attack = dummy.get_node("Sprite2D").get_node("HitBox").get_damage()
	var enemy_health = health_component.visual_health.value
	
	await await_millis(500)
	
	assert_that(int(health_component.visual_health.value)).is_equal(int(enemy_health - dummy_attack))

func test_enemy_dies_when_health_is_zero_or_less() -> void:
	var health_component = enemy.get_node("HealthComponent")
	enemy.get_node("AttackRangeComponent").queue_free()
	
	dummy = Utils.create_dummy(-5, 0)
	scene.add_child(dummy)
	
	dummy.attack()
	await await_millis(1000)
	
	dummy.attack()
	await await_millis(1000)
	
	assert_that(int(health_component.visual_health.value)).is_equal(0)
	assert_that(enemy.get_current_animation()).is_equal("death")

func test_enemy_stop_attacking_when_in_attack_range_and_target_is_dead() -> void:
	var enemy_attack_visuals = enemy.get_node("AnimationPlayer2")
	var enemy_attack_range_area = enemy.get_node("AttackRange")
	var ar_owner = enemy_attack_range_area.get_shape_owners()[0]
	var RANGE_DISTANCE = -(enemy_attack_range_area.shape_owner_get_shape(ar_owner, 0).radius)
	
	dummy = Utils.create_dummy(RANGE_DISTANCE, 0)
	dummy.set_health(10)
	scene.add_child(dummy)
	var dummy_visuals = dummy.get_node("AnimatedSprite2D")
	
	await await_millis(1000)
	
	assert_str(dummy_visuals.animation).is_equal("death")
	assert_str(enemy_attack_visuals.get_current_animation()).is_not_equal("basic_attack")
	
