class_name TeamDisplay extends GridContainer

@export var dwarf_display_template : PackedScene = preload("res://scenes/ui/dwarf_display.tscn")

@onready var display_container : VBoxContainer = $DisplayContainer/VBoxContainer

var displays : Array[DwarfDisplay]

func _ready():
	var world : World = get_tree().get_first_node_in_group("World")
	world.connect("dwarf_count_changed", _on_dwarf_count_changed)


func _on_dwarf_count_changed():
	var dwarves = get_tree().get_nodes_in_group("Dwarf")
	var new_displays : Array[DwarfDisplay] = []
	for display in displays:
		display.queue_free()
	for dwarf in dwarves:
		var display = dwarf_display_template.instantiate()
		new_displays.append(display)
		display_container.add_child(display)
		display.update_data(dwarf)
	displays = new_displays
