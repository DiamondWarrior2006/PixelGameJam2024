extends Node2D


var Room = preload("res://Scenes/Room.tscn")
var Player = preload("res://Scenes/player_fish.tscn")
var Collectable = preload("res://Scenes/collectable.tscn")
var font = preload("res://Fonts/PixeloidMono-d94EV.ttf")
var Shark = preload("res://Scenes/shark.tscn")

@onready var Map = $TileMap

var tile_size = 64
var num_rooms = 25
var min_size = 8
var max_size = 15
var horiz_spread = 100
var cull = 0.5

var shark_position

var path
var play_mode = false
var start_room = null
var end_room = null
var shark_room = null
var player = null
var shark = null
var algae = null

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
		r.make_room(pos, Vector2(wid + 1, hig + 1) * tile_size)
		$Rooms.add_child(r)
	await(get_tree().create_timer(0.5).timeout)
	
	var room_pos = []
	for room in $Rooms.get_children():
		if randf() < cull:
			room.queue_free()
		else:
			room.freeze = true
			room_pos.append(Vector2(room.position.x, room.position.y))
	await get_tree().process_frame
	
	path = find_mst(room_pos)
	make_map()
	await(get_tree().create_timer(0.5).timeout)
	
	find_start_room()
	find_end_room()
	player = Player.instantiate()
	add_child(player)
	player.position = start_room.position
	AtmospherePlayer.play_atmo_1()
	algae = Collectable.instantiate()
	add_child(algae)
	algae.position = end_room.position
	play_mode = true

func _draw():
	if start_room:
		pass
#	for room in $Rooms.get_children():
#		draw_rect(Rect2(room.position - room.size, room.size * 2), Color(131, 191, 63), false)
#	if path:
#		for p in path.get_point_ids():
#			for c in path.get_point_connections(p):
#				var pp = path.get_point_position(p)
#				var cp = path.get_point_position(c)
#				draw_line(pp, cp, Color(131, 191, 63), 15, true)

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
					min_dist = p3.distance_to(p2)
					min_pos = p2
					p = p3
		var n = path.get_available_point_id()
		path.add_point(n, min_pos)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_pos)
	return path

func make_map():
	Map.clear()
	
	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position - room.size, room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.local_to_map(full_rect.position)
	var bottomright = Map.local_to_map(full_rect.end)
	for x in range(topleft.x, bottomright.x):
		for y in range(topleft.y, bottomright.y):
			Map.set_cell(0, Vector2i(x, y), 1, Vector2i(1, 1), 0)
	
	var corridors = []
	for room in $Rooms.get_children():
		var s = (room.size / tile_size).floor()
		var pos = Map.local_to_map(room.position)
		var ul = (room.position / tile_size).floor() - s
		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(0, Vector2i(ul.x + x, ul.y + y), 2, Vector2i(0, 0), 0)
				var source_id = Map.get_cell_source_id(0, Vector2i(ul.x + x, ul.y + y))
				var tiles = Vector2i(randi_range(0, 2), randi_range(0, 2))
				if source_id == 2:
					Map.set_cell(1, Vector2i(pos.x, pos.y), 3, tiles, 0)
		var p = path.get_closest_point(Vector2(room.position.x, room.position.y))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.local_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.local_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_corrider(start, end)
		corridors.append(p)

func carve_corrider(start, end):
	var difference_x = sign(end.x - start.x)
	var difference_y = sign(end.y - start.y)
	
	if difference_x == 0:
		difference_x = pow(-1.0, randi() % 2)
	if difference_y == 0:
		difference_y = pow(-1.0, randi() % 2)
		
	var x_over_y = start
	var y_over_x = end
	
	if randi() % 2 > 0:
		x_over_y = end
		y_over_x = start
	for x in range(start.x, end.x, difference_x):
		Map.set_cell(0, Vector2i(x, x_over_y.y), 2, Vector2i(0, 0), 0);
		Map.set_cell(0, Vector2i(x, x_over_y.y + difference_y), 2, Vector2i(0, 0), 0);
	for y in range(start.y, end.y, difference_y):
		Map.set_cell(0, Vector2i(y_over_x.x, y), 2, Vector2i(0, 0), 0);
		Map.set_cell(0, Vector2i(y_over_x.x + difference_x, y), 2, Vector2i(0, 0), 0);

func find_valid_position():
	var cell_coord = Map.local_to_map(player.position)
	var cell_type_id = Map.get_cell_source_id(0, cell_coord, false)
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	player.get_node("Path2D/PathFollow2D").progress = rng.randf_range(0, 3589.84)
	
	if cell_type_id == 2:
		add_shark(shark_position)
	else:
		find_valid_position()
	

func add_shark(shark_pos):
	shark = Shark.instantiate()
	shark.global_position = player.get_node("Path2D/PathFollow2D/Marker2D").global_position
	add_child(shark)

func find_start_room():
	var min_x = INF
	for room in $Rooms.get_children():
		if room.position.x < min_x:
			start_room = room
			min_x = room.position.x

func find_end_room():
	var max_x = -INF
	for room in $Rooms.get_children():
		if room.position.x > max_x:
			end_room = room
			max_x = room.position.x


func _on_spawn_timer_timeout():
	find_valid_position()
	$Node/DespawnTimer.start()


func _on_despawn_timer_timeout():
	shark.queue_free()
	$Node/SpawnTimer.start()
