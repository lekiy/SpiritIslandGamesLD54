class_name PlayerController extends Camera2D

@export var scroll_speed = 100

var drag_start : Vector2
var drag_end : Vector2
var dragging := false
var select_rect = Rect2(0, 0, 10, 10)

@onready var select_region := $SelectionArea
@onready var collision_region := $SelectionArea/CollisionShape2D
var selected = []

func _ready():
	z_index = RenderingServer.CANVAS_ITEM_Z_MAX

func _process(delta):
	var scroll_direction = Vector2(Input.get_axis("move_cam_left", "move_cam_right"), Input.get_axis("move_cam_up", "move_cam_down")).normalized()

	position += scroll_direction*scroll_speed*delta;
	queue_redraw()


func _input(event):
	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		if(event.is_pressed()):
			drag_start = global_position+event.position-(get_viewport_rect().size*0.5)
			select_rect.position = Vector2(drag_start)
			select_rect.size = Vector2(1, 1)
			dragging = true
			for node in selected:
				if(!node == null):
					node.selected = false
			selected = []
		else:
			dragging = false
			var nodes = get_tree().get_nodes_in_group("Selectable")
			for node in nodes:
				if(select_rect.abs().has_point(node.global_position)):
					if(node.is_controlled_by_player):
						selected.append(node)
						node.selected = true
	if(event is InputEventMouseMotion and dragging):
		drag_end = global_position+event.position-(get_viewport_rect().size*0.5)
		select_rect.size = drag_end-drag_start
	
#	if(event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT):
#		if(event.is_pressed()):
#			if(selected.size() > 0):
#				var targets = get_tree().get_nodes_in_group("Targetable")
#				for target in targets:
#					pass

func on_right_clicked(node):
	if(selected.size()):
		for select in selected:
			select.get_parent().attack_target = node

func _draw():
	if(dragging):
		var drawn_rect = Rect2i(select_rect.position-global_position, select_rect.size)
		draw_rect(drawn_rect, Color.WHITE, false, 1)
