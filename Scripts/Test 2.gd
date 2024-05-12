extends Node2D


var Room = preload("res://Room.tscn")

var tile_size = 64
var num_rooms = 15
var min_size = 4
var max_size = 10
var horiz_spread = 300
var cull = 0.5

var path

func _ready():
	randomize()
	make_rooms()

func _process(delta):
	queue_redraw()

func make_rooms():
	for i in range(num_rooms):
		var pos = Vector2(randf_range(-horiz_spread, horiz_spread), 0)
		var r = Room.instantiate()
		var wid = min_size + randi() % (max_size - min_size)
		var hig = min_size + randi() % (max_size - min_size)
		r.make_room(pos, Vector2(wid, hig) * tile_size)
		$Rooms.add_child(r)
	await(get_tree().create_timer(1.1).timeout)
	
	var room_pos = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
			room_pos.append(Vector2(room.position.x, room.position.y))
	await get_tree().process_frame
	
	path = find_mst(room_pos)

func _draw():
	for room in $Rooms.get_children():
		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(131, 191, 63), false)
	if path:
		for p in path.get_point_ids():
			for c in path.get_point_connections(p):
				var pp = path.get_point_position(p)
				var cp = path.get_point_position(c)
				draw_line(pp, cp, Color(131, 191, 63), 15, true)

func _input(event):
	if event.is_action_pressed("ui_down"):
		for n in $Rooms.get_children():
			n.queue_free()
		make_rooms()

func find_mst(nodes):
	var path = AStar2D.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())
	
	while nodes:
		var min_dist = INF
		var min_pos = null
		var p = null
		
		for p1 in path.get_point_ids():
			var p3 = path.get_point_position(p1)
			for p2 in nodes:
				if p3.distance_to(p2) < min_dist:
					min_dist = p3.distance_squared_to(p2)
					min_pos = p2
					p = p3
		var n = path.get_available_point_id()
		path.add_point(n, min_pos)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_pos)
	return path
