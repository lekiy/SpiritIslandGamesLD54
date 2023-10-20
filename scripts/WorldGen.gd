class_name WorldGen extends Node2D


@export var width = 60
@export var height = 60
@export var world_seed = "Dwarves!"
@export var noise_octaves = 4
@export var noise_type = FastNoiseLite.TYPE_SIMPLEX
@export var noise_frequency : float = 0.1
@export var noise_gain : float = 0.5
@export var noise_lacunarity : float = 0.5
@export var noise_threshhold : float = 0
@export var show_generated := false

var noise : FastNoiseLite = FastNoiseLite.new() 

var cell_map = []

# Called when the node enters the scene tree for the first time.
func _ready():
	clear()
	generate()

func clear():
	cell_map = []

func redraw():
	# if(regen):
	clear()
	generate()
		# regen = false

func generate():
	noise.seed = world_seed.hash()
	noise.fractal_octaves = noise_octaves
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = noise_frequency
	noise.fractal_gain = noise_gain
	noise.fractal_lacunarity = noise_lacunarity

	for x in width:
		for y in height:
			if(noise.get_noise_2d(x, y) <= noise_threshhold):
				cell_map.append(1)
			else:
				cell_map.append(0)


func _process(_delta):
	if(show_generated):
		queue_redraw()
		redraw()	

func _draw():
	if(show_generated):
		var cell_size = 1
		for x in width:
			for y in height:
				var value = cell_map[x+y*width]
				var color = Color(value, value, value)
				draw_rect(Rect2(Vector2(x*cell_size, y*cell_size), Vector2(cell_size, cell_size	)), color) 
