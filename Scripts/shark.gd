extends CharacterBody2D

var player = null
var speed = 200

var rotation_speed = 15

var moving = false

func _physics_process(delta):
	if player:
		velocity = position.direction_to(player.position) * speed
		
		var direction = player.position - global_position
		var angle_to = transform.x.angle_to(direction)
		rotate(sign(angle_to) * min(delta * rotation_speed, abs(angle_to)))
	else:
		velocity = Vector2.ZERO
	move_and_slide()


func _on_area_2d_body_entered(body):
	player = body
	moving = true


func _on_area_2d_body_exited(body):
	player = null
	moving = false
