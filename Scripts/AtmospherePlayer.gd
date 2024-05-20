extends AudioStreamPlayer

@onready var atmo_0 = preload("res://SFX/AtmosOcean_Depth0.wav")
@onready var atmo_1 = preload("res://SFX/AtmosOcean_Depth1.wav")
@onready var atmo_2 = preload("res://SFX/AtmosOcean_Depth2.wav")

var isPlayingAtmo0 = false
var isPlayingAtmo1 = false

func play_atmo_0():
	stream = atmo_0
	set_bus("SFX")
	play()

func play_atmo_1():
	stream = atmo_1
	set_bus("SFX")
	play()

func play_atmo_2():
	stream = atmo_2
	set_bus("SFX")
	play()
