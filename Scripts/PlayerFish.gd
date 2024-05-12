extends CharacterBody2D

var speed
var normal_speed = 400
var dash_speed = 800
var rotation_speed = 15

var dashing = false
var moving = false

func _ready():
	speed = normal_speed

func _physics_process(delta):
	# Player Dashing
	var direction = rotation
	if dashing == true:
		speed = dash_speed
	else:
		speed = normal_speed
	
	if Input.is_action_just_pressed("Dash") :
		dashing = true
		$Timer.start()
	
	player_movement(delta)
	move_and_slide()

func player_movement(delta):
	# Player Movement
	if Input.is_action_pressed("move"):
		velocity = transform.x * speed
		moving = true
	else:
		velocity = velocity.move_toward(Vector2.ZERO, 300 * delta)
		moving = false
	# Player Rotation
	var direction = get_global_mouse_position() - global_position
	var angle_to = transform.x.angle_to(direction)
	rotate(sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))


func _on_timer_timeout():
	dashing = false
