extends Area2D

var sprite

func _ready() -> void:
	sprite = get_node("face")

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int):
	if(event is InputEventMouseButton):
		if(event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
			sprite.frame = 3
		if(event.is_released() and event.button_index == MOUSE_BUTTON_LEFT):
			sprite.frame = 0
			get_parent().reset_game.emit()

func _process(delta: float) -> void:
	pass
