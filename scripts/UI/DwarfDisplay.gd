class_name DwarfDisplay extends VBoxContainer

@onready var texture_rect : TextureRect = $HBoxContainer/TextureRect
@onready var label : Label = $HBoxContainer/Label
@onready var healthbar : GuiHealthBar = $GuiHealthBar

var dwarf : Dwarf

func update_data(dwarf_instance):
	dwarf = dwarf_instance
	label.text = dwarf.display_name
	healthbar.set_max_hearts(dwarf.max_health)
