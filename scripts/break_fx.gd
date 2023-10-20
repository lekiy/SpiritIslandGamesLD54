class_name BreakFX extends AnimatedSprite2D


@onready var world := get_parent()

var health = 8;
var max_health;

func _process(_delta):
	var tile = world.local_to_map(position)
	health = world.tile_durability_matrix[tile.x][tile.y]

	match health:
		6:
			frame = 0
		4:
			frame = 1
		2:
			frame = 2
		0:
			queue_free()

