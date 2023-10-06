class_name GuiHealthBar extends HBoxContainer

@onready var heart_scene := preload("res://scenes/ui/gui_heart.tscn")

func set_max_hearts(max_health: int):
	for i in max_health:
		var heart = heart_scene.instantiate()
		add_child(heart)
