extends Sprite2D

@export var sprite_node: CanvasItem = get_parent()
@onready var outline_shader = preload("res://scripts/shaders/outline.gdshader")
@onready var outline_material = ShaderMaterial.new()
@onready var previous_material
# Called when the node enters the scene tree for the first time.
func _ready():
	if(sprite_node is CanvasItem):
		previous_material = sprite_node.material
		outline_material.shader = outline_shader

	if(sprite_node is CanvasItem):
		sprite_node.material = outline_material

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
