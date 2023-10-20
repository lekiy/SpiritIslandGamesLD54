extends Area2D


@onready var region : CollisionShape2D = $CollisionShape2D

@onready var fog: Fog = get_tree().get_first_node_in_group("Fog")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	fog.add_safe_region(self, global_position, region.shape.radius)
