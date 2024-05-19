extends AudioStreamPlayer


@onready var normal_theme = preload("res://Music/ST_Soft.wav")
@onready var alert_theme = preload("res://Music/ST_Alert.wav")
@onready var active_theme = preload("res://Music/ST_Active.wav")

func play_normal_theme():
	stream = normal_theme
	volume_db = -10
	play()

func play_alert_theme():
	stream = alert_theme
	volume_db = -10
	play()

func play_active_theme():
	stream = active_theme
	volume_db = -10
	play()
