extends Node2D

signal reset_game

var face

func _on_tiles_pressed() -> void:
	face.frame = 1

func _on_tiles_released() -> void:
	match(Global.GameState):
		0: face.frame = 2
		1: face.frame = 0
		2: face.frame = 0
		3: face.frame = 4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	face = get_node("Area2D/face")
