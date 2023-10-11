extends Camera2D

@export var scroll_speed = 100

var drag_start : Vector2
var drag_end : Vector2
var dragging := false
var select_rect = RectangleShape2D.new()
var selected = []

func _process(delta):
	var scroll_direction = Vector2(Input.get_axis("move_cam_left", "move_cam_right"), Input.get_axis("move_cam_up", "move_cam_down")).normalized()

	position += scroll_direction*scroll_speed*delta;
	# queue_redraw()


# func _input(event):
# 	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
# 		if(event.is_pressed()):
# 			if selected.size() == 0:
# 				dragging = true
# 				drag_start = event.position- Vector2(160, 90)
# 		elif dragging:
# 			dragging = false
# 	if event is InputEventMouseMotion and dragging:
# 		pass # update()
# # 		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT and !is_selecting:
# # 			select_start = event.position - Vector2(160, 90)
# # 			select_end = select_start
# # 			is_selecting = true
# # 		elif event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
# # 			is_selecting = false
# # 			select_end = event.position - Vector2(160, 90)
# # 			# select_shape.shape = RectangleShape2D.new()
# # 			select_shape.shape.size = select_end-select_start
# # 			select_shape.position = select_start
# # 			var selected_nodes = select_area.get_overlapping_areas()
# # 			for area in selected_nodes:
# # 				if(area is SelectionComponent):
# # 					area.selected = true
# # 	if event is InputEventMouseMotion and is_selecting:
# # 		select_end = event.position - Vector2(160, 90)
		

	

# func _draw():
# 	if(dragging):
# 		var rect = Rect2(drag_start, get_global_mouse_position()-drag_start-position)
# 		print(rect)
# 		draw_rect(rect, Color.ALICE_BLUE, false)

	
