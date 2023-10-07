class_name GuiHealthBar extends HBoxContainer

@onready var heart_scene := preload("res://scenes/ui/gui_heart.tscn")

func set_max_hearts(max_health: int):
	for i in max_health*0.5:
		var heart = heart_scene.instantiate()
		add_child(heart)
	update_hearts(max_health)

func update_hearts(current_health: int):
	var hearts = get_children()
	for i in range(1, hearts.size()+1):
		if(i*2 <= current_health):
			hearts[i-1].update(2)
		elif(i*2 > current_health+1):
			hearts[i-1].update(0)
		else:
			hearts[i-1].update(1)
	
