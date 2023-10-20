class_name HealthComponent extends Node

@export var max_health = 6
@export var flash_time = 0.1

@onready var flash_shader = preload("res://scripts/shaders/flash.gdshader")
@export var sprite_node: CanvasItem = get_parent()

var health
# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health
	
	if(sprite_node is CanvasItem):
		sprite_node.material = ShaderMaterial.new()
		sprite_node.material.shader = flash_shader
		sprite_node.material.set("shader_parameter/flash_color", Color.WHITE)
	
func damage(damage_amount: int):
	health -= damage_amount
	if(sprite_node is CanvasItem):
		sprite_node.material.set("shader_parameter/enabled", true)
	if health <= 0:
		get_parent().queue_free()

	await get_tree().create_timer(flash_time).timeout
	if(sprite_node is CanvasItem):
		sprite_node.material.set("shader_parameter/enabled", false)
