class_name HealthComponent extends Node

@export var max_health = 6
@export var flash_time = 0.1

@onready var flash_shader = preload("res://scripts/shaders/flash.gdshader")
@onready var flash_material = ShaderMaterial.new()
@onready var previous_material
@export var sprite_node: CanvasItem = get_parent()

var health
# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	
	if(sprite_node is CanvasItem):
		previous_material = sprite_node.material
		flash_material.shader = flash_shader
		flash_material.set("shader_parameter/flash_color", Color.WHITE)
		flash_material.set("shader_parameter/enabled", true)
	
func damage(damage_amount: int):
	health -= damage_amount
	create_flash()
	if health <= 0:
		get_parent().queue_free()
		
func create_flash():
	if(sprite_node is CanvasItem):
		
		sprite_node.material = flash_material
		await get_tree().create_timer(flash_time).timeout
		sprite_node.material = previous_material
