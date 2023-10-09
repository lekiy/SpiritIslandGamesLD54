class_name InventoryComponent extends Area2D

@export var max_carry_weight = 5
@export var inventory := [];

func get_total_weight():
	var weight = 0
	for item in inventory:
		weight += item.weight
	return weight

func _on_area_entered(area:Area2D):
	if(area is Pickup):
		var pickup : Pickup = area
		if((max_carry_weight - get_total_weight()) >= pickup.item.weight):
			get_tree().create_timer(.5).timeout
			inventory.append(pickup.item)
			pickup.queue_free();
			print("picked up")
			
