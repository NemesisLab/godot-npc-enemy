extends Node

static func create_dummy(x_coord, y_coord):
	var dummy = preload("res://test/mocks/dummy.tscn").instantiate()
	dummy.translate(Vector2(x_coord, y_coord))
	return dummy

static func create_dead_dummy(x_coord, y_coord):
	var dummy = preload("res://test/mocks/dummy.tscn").instantiate()
	dummy.translate(Vector2(x_coord, y_coord))
	dummy.set_dead()
	return dummy
