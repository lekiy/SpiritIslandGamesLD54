class_name PathingComponent extends Node

var path : PackedVector2Array
@onready var world : World = get_tree().get_first_node_in_group("World")
@onready var parent : CharacterBody2D = get_parent()
var path_index = 0
var has_path = false

var path_line: Line2D
var draw_line = false

func move_to_tile(target_tile_pos):
	path = world.get_move_path(parent.position, target_tile_pos)
	if(draw_line):
		setup_line(path)
	if(path.size() >= 1): #skips the first index of 0 so that we dont path to the tile we are already occupying
		path_index = 1
		has_path = true
	else:
		has_path = false
		#may need to force stop movement here


func get_direction_to_path() -> Vector2 :
	if(path_index >= path.size()):
		has_path = false;
		path_index = 0;
		return Vector2.ZERO

	var dir = parent.position.direction_to(path[path_index])
	if(path.size() > 0 and parent.position.distance_to(path[path_index]) <= 1):
		path_index+=1;
		
	return dir

func setup_line(_path: Array[Vector2]):
	pass

func clear_path():
	path = []
	path_index = 0
	has_path = false
