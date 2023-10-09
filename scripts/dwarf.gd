class_name Dwarf extends CharacterBody2D

@export var selected := false
@export var move_speed := 50
@export var dig_strength := 2
@export var dig_speed := 1
@export var max_health = 6
var health


@onready var click_region : Area2D = $ClickRegion
@onready var selector_sprite : Sprite2D = $Selector
@onready var world : TileMap = get_parent()
@onready var sprite = $AnimatedSprite2D
@onready var path_line_scene := preload("res://scenes/path_line.tscn")
@onready var wall_selection_scene := preload("res://scenes/wall_selection.tscn")
@onready var pathing : PathingComponent = $PathingComponent

const WALL_TEX_COORD = Vector2i(1, 1)
const FLOOR_TEX_COORD = Vector2i(1, 4)

var inventory = []
@export var carry_weight = 5

enum action {
	IDLE,
	ATTACK,
	MOVE,
	DIG,
	DEATH
}

const directions = [Vector2.UP, Vector2.DOWN, Vector2.RIGHT, Vector2.LEFT]
var display_name
var lifetime = 0;
var mouse_over = false;
var action_state = action.IDLE
var can_dig = true
var dig_target
var facing_direction = Vector2.DOWN

var path_line: Line2D
var wall_selection: Polygon2D

func _ready():
	path_line = path_line_scene.instantiate()
	world.get_node("PathingUI").add_child(path_line)
	path_line.visible = false
	
	wall_selection = wall_selection_scene.instantiate()
	world.get_node("PathingUI").add_child(wall_selection)
	wall_selection.visible = false

	health = max_health

	display_name = get_dwarf_name()

func _input(event):
	if(event is InputEventMouse):
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			if(mouse_over):
				selected = true
				
			else:
				selected = false;
				
			
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_RIGHT and selected:
			var camera = get_parent().get_node("GameCamera")
			var target_pos : Vector2 = camera.position + event.position - Vector2(160, 90)
			
			var tile = world.get_tile(target_pos)
			var tile_health = tile.get_custom_data("Durability")
			if(tile_health):
				dig_target = target_pos
				
			action_state = action.MOVE
			pathing.move_to_tile(target_pos)

func get_dwarf_name():
	var names = [
		"Reginald",
		"Karl",
		"Gondred",
		"Mifrend",
		"Hisfrend",
		"Dranle",
		"Grizzly",
		"Todard",
		"Pagruph",
		"balgruff"
	]

	names.shuffle()
	return names[0]

func set_facing_direction():
	
	var closest = Vector2.DOWN
	for dir in directions:
		if(velocity.distance_to(dir) < velocity.distance_to(closest)):
			closest = dir
			
	facing_direction = closest
		

func update_selected():
	if selected:
		selector_sprite.visible = true
		path_line.visible = true
		wall_selection.visible = true
		
	else:
		selector_sprite.visible = false
		path_line.visible = false
		wall_selection.visible = false

func _physics_process(_delta):
	if(health <= 0):

		action_state = action.DEATH
		queue_free() #will need to pull out later till end of death step

	update_selected()

	lifetime+=1;
	selector_sprite.position.y += (pingpong(lifetime*0.5, 4)-2)*.25

	if(selected and dig_target):
		var origin = world.map_to_local(world.local_to_map(dig_target))-Vector2(world.CELL_SIZE/2, world.CELL_SIZE/2)
		wall_selection.polygon = ([origin, Vector2(origin.x+world.CELL_SIZE, origin.y), Vector2(origin.x+world.CELL_SIZE, origin.y+world.CELL_SIZE), Vector2(origin.x, origin.y+world.CELL_SIZE)])
		wall_selection.visible = true;
		

	match action_state:
		action.IDLE:
			velocity = Vector2.ZERO
			wall_selection.visible = false;
			set_anim_direction("idle")
		action.MOVE:
			if(pathing.has_path):
				velocity = pathing.get_direction_to_path() * move_speed
				# sprite.rotation = deg_to_rad(pingpong(lifetime*2, 10)-5)
				set_facing_direction()
				set_anim_direction("walk")
				
			else:
				sprite.rotation = 0
				path_line.points = []
				if(dig_target):
					action_state = action.DIG
				else:
					action_state = action.IDLE
		action.DIG:
			if(!dig_target):
				action_state = action.IDLE
			else:
				if(can_dig):
					var remainder = world.dig_tile(dig_target, dig_strength)
					can_dig = false;
					if(remainder <= 0):
						dig_target = null
						action_state = action.IDLE
					await get_tree().create_timer(dig_speed).timeout
					can_dig = true
					
					
	move_and_slide()

func set_anim_direction(animation_sub_name: String):
	match facing_direction:
		Vector2.DOWN:
			sprite.play(animation_sub_name+"_forward")
		Vector2.UP:
			sprite.play(animation_sub_name+"_back")
		Vector2.RIGHT:
			sprite.play(animation_sub_name+"_side")
			sprite.flip_h =true
		Vector2.LEFT:
			sprite.play(animation_sub_name+"_side")
			sprite.flip_h = false

func _on_click_region_mouse_exited():
	mouse_over = false

func _on_click_region_mouse_entered():
	mouse_over = true

func _on_tree_exited():
	world.remove_dwarf()
