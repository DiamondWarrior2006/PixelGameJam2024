extends Control

@export var ui : UI
@export var settingsPanel : Panel

# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	ui.connect("toggle_game_paused", _on_ui_toogle_game_paused)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_ui_toogle_game_paused(is_paused : bool):
	if is_paused:
		show()
	else:
		hide()


func _on_resume_pressed():
	ui.game_paused = false


func _on_resume_3_pressed():
	ui.game_paused = false
	get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")


func _on_resume_2_pressed():
	$Panel/Panel.show()
