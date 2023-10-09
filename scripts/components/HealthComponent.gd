class_name HealthComponent extends Node

@export var max_health = 6
var health
# Called when the node enters the scene tree for the first time.
func _ready():
	health = max_health

func damage(damage_amount: int):
	health -= damage_amount
	if health <= 0:
		get_parent().queue_free()
