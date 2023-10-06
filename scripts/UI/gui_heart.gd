extends Panel

@onready var sprite = $Sprite2D

func update(state: int):
	match state:
		2: sprite.frame = 0
		1: sprite.frame = 1
		0: sprite.frame = 2