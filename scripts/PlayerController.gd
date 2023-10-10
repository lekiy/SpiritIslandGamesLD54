extends Camera2D

@export var scroll_speed = 100

var select_start : Vector2
var select_end : Vector2
var is_selecting := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var scroll_direction = Vector2(Input.get_axis("move_cam_left", "move_cam_right"), Input.get_axis("move_cam_up", "move_cam_down")).normalized()

	position += scroll_direction*scroll_speed*delta;
	queue_redraw()

func _input(event):
	if(event is InputEventMouseButton):
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and !is_selecting:
			select_start = event.position - Vector2(160, 90)
			select_end = select_start
			is_selecting = true
		elif event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			is_selecting = false
			select_end = event.position - Vector2(160, 90)
	if event is InputEventMouseMotion and is_selecting:
		select_end = event.position - Vector2(160, 90)

	

func _draw():
	# if(is_selecting):
		var rect = Rect2(select_start, select_end-select_start)
		draw_rect(rect, Color.ALICE_BLUE, false)

	
