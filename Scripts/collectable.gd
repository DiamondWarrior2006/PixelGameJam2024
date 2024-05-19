extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()

func _on_body_entered(body):
	if body.name == "PlayerFish":
		$AnimatedSprite2D.visible = false
		$CollisionShape2D.disabled = true
		$AudioStreamPlayer2D2.play()
		$AudioStreamPlayer2D.stop()
		ScoreSystem.score -= 1
		$Timer.start()


func _on_timer_timeout():
	get_tree().reload_current_scene()
