class_name World extends TileMap

@export var map_width = 60
@export var map_height = 60
@export var map_border: Rect2

const FLOOR_LAYER = 0
const RESOURCE_LAYER = 1
const ATLAS = 0

const WALL_TEX_COORD = Vector2i(0, 2)
const FLOOR_TEX_COORD = Vector2i(1, 4)
const CELL_SIZE = 20

@onready var camera := $GameCamera
# @onready var line = $Line2D
# @onready var selection_poly = $Polygon2D
@onready var pathing_ui = $PathingUI
@onready var astar = AStarGrid2D.new()
@onready var minimap_scene := preload("res://scenes/ui/minimap.tscn")
@onready var spawn_scene := preload("res://scenes/spawn_cave.tscn")
@onready var break_fx := preload("res://scenes/break_fx.tscn")

@onready var dwarf_scene := preload("res://scenes/units/dwarf.tscn")
@onready var goblin_scene := preload("res://scenes/goblin.tscn")

@onready var torch_scene := preload("res://scenes/torch.tscn")
@onready var rock_scene := preload("res://scenes/pickup_rock.tscn")
@onready var world_gen := $WorldGen
@onready var stone_gen := $StoneGen

@onready var crystal := $MainCrystal
@onready var fog := $Fog

var max_dwarves = 2
var dwarves_count = 0

signal dwarf_count_changed()

var tile_durability_matrix
var mouse_position

const dirs = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]

var minimap

# var cave_noise_generator = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	
	astar.region = Rect2i(0, 0, map_width, map_height)
	astar.cell_size = Vector2i(CELL_SIZE, CELL_SIZE)
	astar.offset = Vector2i(CELL_SIZE*0.5, CELL_SIZE*0.5)
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	astar.default_compute_heuristic = AStarGrid2D.HEURISTIC_EUCLIDEAN
	astar.update()
	
	fill_world()
	# add_spawn_area()
	spawn_dwarf()

	# update_cell_terrain()
	fog.position = Vector2(map_width*CELL_SIZE*0.5, map_height*CELL_SIZE*0.5)
	fog.texture.width = map_width*CELL_SIZE
	fog.texture.height = map_height*CELL_SIZE
	fog.z_index = RenderingServer.CANVAS_ITEM_Z_MAX-1
	crystal.position = map_to_local(Vector2(map_width*0.5, map_height*0.5))
	setup_durability_matrix()

func _input(event):
	if(event is InputEventMouse):
		mouse_position = event.position

func setup_durability_matrix():
	var matrix = []
	for x in map_width:
		matrix.append([])
		for y in map_height:
			var tile_data = get_cell_tile_data(FLOOR_LAYER, Vector2i(x, y))
			if(tile_data):
				matrix[x].append(tile_data.get_custom_data("Durability"))
			else:
				matrix[x].append(0)
	tile_durability_matrix = matrix
	

func fill_world():
	# cave_noise_generator.seed = randi()
	print(get_layer_name(RESOURCE_LAYER))
	for x in map_width:
		for y in map_height:
			astar.set_point_solid(Vector2i(x, y), true)
			set_cell(FLOOR_LAYER, Vector2i(x, y), ATLAS, WALL_TEX_COORD)
	
	for x in map_width:
		for y in map_height:
			var floor_tile = world_gen.cell_map[x+y*map_width]
			if(floor_tile):
				astar.set_point_solid(Vector2i(x, y), false)
				set_cells_terrain_connect(FLOOR_LAYER, [Vector2i(x, y)], 0, 0)
				var stone = stone_gen.cell_map[x+y*map_width]
				if(stone):
					set_cell(RESOURCE_LAYER, Vector2i(x, y), 1, Vector2i(randi_range(0, 4), 0))
					astar.set_point_solid(Vector2i(x, y), true)

				

func add_spawn_area():
	var spawn_tilemap = spawn_scene.instantiate()
	var size : Vector2i = spawn_tilemap.get_used_rect().size
	var start_pos = get_world_map_center() - size/2
	for x in size.x:
		for y in size.y:
			var tile_data = spawn_tilemap.get_cell_tile_data(FLOOR_LAYER, Vector2i(x, y))
			var tile_type = spawn_tilemap.get_cell_atlas_coords(FLOOR_LAYER, Vector2i(x, y))
			if(tile_data):
				set_cell(FLOOR_LAYER, start_pos+Vector2i(x, y), ATLAS, tile_type)
				
				if(tile_type == WALL_TEX_COORD):
					astar.set_point_solid(start_pos+Vector2i(x, y), true)
				else:
					astar.set_point_solid(start_pos+Vector2i(x, y), false)

func update_cell_terrain():
	var cells = get_used_cells(FLOOR_LAYER);
	for cell in cells:
		var tile_type = get_cell_atlas_coords(FLOOR_LAYER, cell)
		if(tile_type == FLOOR_TEX_COORD):
			set_cells_terrain_connect(FLOOR_LAYER, [cell], 0, 0)

func _process(_delta):
	if(Input.is_action_just_pressed("spawn_dwarf")):
		spawn_dwarf()

	if(Input.is_action_just_pressed("spawn_enemy")):
		spawn_enemy(goblin_scene, get_world_mouse_position())
	if(Input.is_action_just_pressed("spawn_light")):
		spawn_object(torch_scene, get_world_mouse_position())

		

	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

	


func get_world_mouse_position():
	return mouse_position+camera.position- Vector2(160, 90)
	
func spawn_dwarf():
	if(dwarves_count < max_dwarves):
		var new_dwarf = dwarf_scene.instantiate()
		add_child(new_dwarf)
		dwarves_count+=1
		emit_signal("dwarf_count_changed")
		new_dwarf.position = get_world_map_center()*CELL_SIZE
		camera.position = new_dwarf.position

func remove_dwarf():
	dwarves_count -= 1
	emit_signal("dwarf_count_changed")

func spawn_enemy(enemy_scene, spawn_position):
	var enemy = enemy_scene.instantiate()
	add_child(enemy)

	enemy.position = spawn_position

func spawn_object(object_scene, spawn_position):
	var object = object_scene.instantiate()
	add_child(object)

	object.position = spawn_position


func get_world_map_center():
	return Vector2(map_width*0.5, map_height*0.5)

func get_move_path(start: Vector2, target: Vector2):
	var type = get_cell_atlas_coords(FLOOR_LAYER, local_to_map(target))
	if(type == WALL_TEX_COORD):
		var neighbors = get_surrounding_cells(local_to_map(target))
		neighbors.sort_custom(func(a, b): return start.distance_to(map_to_local(a)) < start.distance_to(map_to_local(b)))
		for cell in neighbors:
			if(get_cell_atlas_coords(FLOOR_LAYER, cell) != WALL_TEX_COORD):
				return astar.get_point_path(local_to_map(start), cell)
		return [];
	else:
		return astar.get_point_path(local_to_map(start), local_to_map(target))
		

func get_tile(target):
	return get_cell_tile_data(FLOOR_LAYER, local_to_map(target))
	
func dig_tile(target: Vector2, dig_damage):
	var tile = local_to_map(target)
	var durability_value = tile_durability_matrix[tile.x][tile.y]
	tile_durability_matrix[tile.x][tile.y] -= dig_damage
	durability_value -= dig_damage

	if(durability_value == 6):
		var fx = break_fx.instantiate()
		fx.position = map_to_local(tile)
		add_child(fx)

	if(durability_value <= 0):
		destroy_tile(local_to_map(target))
	return durability_value

func destroy_tile(target_cell):
	var tile_type = get_cell_atlas_coords(FLOOR_LAYER, target_cell)
	set_cells_terrain_connect(FLOOR_LAYER, [target_cell], 0, 0)
	astar.set_point_solid(target_cell, false)
	spawn_resources(target_cell, tile_type)

func spawn_resources(tile_position, tile_type):
	match tile_type:
		WALL_TEX_COORD:
			for i in randi_range(1, 2):
				var rock = rock_scene.instantiate()
				add_child(rock)
				rock.position = map_to_local(tile_position)+Vector2(randf_range(-CELL_SIZE*0.25, CELL_SIZE*0.25), randf_range(-CELL_SIZE*0.25, CELL_SIZE*0.25))


