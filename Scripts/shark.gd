extends CharacterBody2D

@onready var animator = $AnimatedSprite2D

var player = null
var speed = 300

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
	animations()
	move_and_slide()

func animations():
	if moving == true:
		animator.play("Moving")
	else:
		animator.play("Idle")

func _on_area_2d_body_entered(body):
	if body.name == "PlayerFish":
		player = body
		moving = true
		player.is_being_chased = true


func _on_area_2d_body_exited(body):
	if body.name == "PlayerFish":
		player = null
		moving = false
		player.is_being_chased = false


func _on_area_2d_2_body_entered(body):
	if body.name == "PlayerFish":
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
