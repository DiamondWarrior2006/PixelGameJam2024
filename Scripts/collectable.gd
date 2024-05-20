extends Area2D

var picked_up = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AudioStreamPlayer2D.play()

func _on_body_entered(body):
	if body.name == "PlayerFish":
		if picked_up == false:
			$AnimatedSprite2D.visible = false
			$CollisionShape2D.call_deferred("disabled", true)
			$AudioStreamPlayer2D2.play()
			$AudioStreamPlayer2D.stop()
			$Timer.start()
			ScoreSystem.score -= 1
			picked_up = true


func _on_timer_timeout():
	get_tree().reload_current_scene()
