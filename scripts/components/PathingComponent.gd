class_name PathingComponent extends Node2D

var path : PackedVector2Array
@onready var world : World = get_tree().get_first_node_in_group("World")
@onready var parent : CharacterBody2D = get_parent()
@export var show_debug_line := false
var path_index = 0
var has_path = false

var path_line: Line2D
var previous_tile : Vector2i
var target_position

func set_target(target_pos):
	target_position = target_pos
	move_to_tile()
	
func get_target():
	return target_position

func _process(_delta):
	if(target_position and !has_path):
		move_to_tile()
	queue_redraw()
	
func move_to_tile():
	path = world.get_move_path(parent.position, target_position)
	
	if(path.size() >= 1): #skips the first index of 0 so that we dont path to the tile we are already occupying
		path_index = 1
		has_path = true
	else:
		has_path = false
		#may need to force stop movement here
		

func get_direction_to_path() -> Vector2 :
	
	if(path_index >= path.size()):
		clear_path()
		return Vector2.ZERO
		
	if(world.local_to_map(parent.position) != world.local_to_map(path[path_index])):
		if(world.astar.is_point_solid(world.local_to_map(path[path_index]))):
			move_to_tile()
	
	if(!has_path): return Vector2.ZERO
	
	var dir = parent.position.direction_to(path[path_index])
	if(path.size() > 0 and parent.position.distance_to(path[path_index]) <= 1):
		world.astar.set_point_solid(world.local_to_map(parent.position), false);
		world.astar.set_point_solid(world.local_to_map(path[path_index]), true);
		path_index+=1;
		
	return dir

func setup_line(_path: Array[Vector2]):
	pass

func clear_path():
	path = []
	path_index = 0
	has_path = false
	
func _draw():
	if(show_debug_line):
		for i in path.size()-1:
			draw_line(path[i]-global_position, path[i+1]-global_position, Color.WHITE, 1, false)
		
