extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	ScoreSystem.score = 9


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_button_2_pressed():
	get_tree().change_scene_to_file("res://Scenes/Test 2.tscn")
