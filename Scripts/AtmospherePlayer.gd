extends AudioStreamPlayer

@onready var atmo_0 = preload("res://SFX/AtmosOcean_Depth0.wav")
@onready var atmo_1 = preload("res://SFX/AtmosOcean_Depth1.wav")
@onready var atmo_2 = preload("res://SFX/AtmosOcean_Depth2.wav")

func play_atmo_0():
	stream = atmo_0
	play()

func play_atmo_1():
	stream = atmo_1
	play()

func play_atmo_2():
	stream = atmo_2
	play()
