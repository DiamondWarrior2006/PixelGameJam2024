extends AudioStreamPlayer


@onready var normal_theme = preload("res://Music/ST_SoftExplore1.mp3")
@onready var active_theme = preload("res://Music/ST_ActiveLayerWIP1.mp3")

func play_normal_theme():
	stream = normal_theme
	volume_db = -10
	play()

func play_active_theme():
	stream = active_theme
	volume_db = -10
	play()


