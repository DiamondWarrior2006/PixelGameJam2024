extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	if AtmospherePlayer.isPlayingAtmo0 == false:
		AtmospherePlayer.play_atmo_0()
		AtmospherePlayer.isPlayingAtmo0 = true
	
	MusicPlayer.stop()
	MusicPlayer.isPlayingNormalMusic = false
	AtmospherePlayer.isPlayingAtmo1 = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://Scenes/Test 2.tscn")


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Scenes/options.tscn")


func _on_quit_pressed():
	get_tree().quit()
