extends RigidBody2D


var size

func make_room(pos, _size):
	position = pos
	size = _size
	var shape = RectangleShape2D.new()
	shape.custom_solver_bias = .75
	shape.extents = size
	$CollisionShape2D.shape = shape
