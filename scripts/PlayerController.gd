extends Camera2D

@export var scroll_speed = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scroll_direction = Vector2(Input.get_axis("move_cam_left", "move_cam_right"), Input.get_axis("move_cam_up", "move_cam_down")).normalized()

	position += scroll_direction*scroll_speed*delta;
