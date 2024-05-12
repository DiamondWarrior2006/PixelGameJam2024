extends Control


@onready var label = $VBoxContainer/HBoxContainer/CenterContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_counter()

func update_counter() -> void:
	label.text = "Golden Algaes left: " + str(ScoreSystem.score)
