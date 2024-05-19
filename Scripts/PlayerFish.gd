extends CharacterBody2D

@export var is_being_chased = false

var speed
var normal_speed = 400
var dash_speed = 800
var rotation_speed = 15

var can_dash = true
var dashing = false
var moving = false

func _ready():
	speed = normal_speed
	if is_being_chased == true:
		MusicPlayer.play_active_theme()
	else:
		MusicPlayer.play_normal_theme()

func _physics_process(delta):
	# Player Dashing
	if dashing == true:
		speed = dash_speed
		$CPUParticles2D.emitting = true
	else:
		speed = normal_speed
		$CPUParticles2D.emitting = false
	
	if Input.is_action_just_pressed("Dash") && moving == true && can_dash == true:
		dashing = true
		can_dash = false
		$Timer.start()
	
	
	player_movement(delta)
	player_animation()
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
	$CPUParticles2D.process_material.set_shader_parameter("emission_angle", self.rotation_degrees)

func player_animation():
	if moving == false:
		$Sprite2D.play("Idle")
	else:
		$Sprite2D.play("Moving")

func _on_timer_timeout():
	dashing = false
	$CooldownTimer.start()

func _on_cooldown_timer_timeout():
	can_dash = true

