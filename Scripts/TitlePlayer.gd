extends CharacterBody2D

var speed = 300
var rotation_speed = 15

func _physics_process(delta):
	velocity = transform.x * speed
	
	var direction = get_global_mouse_position() - global_position
	var angle_to = transform.x.angle_to(direction)
	rotate(sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))
	
	move_and_slide()
