class_name SelectionComponent extends Area2D

var selected := false 
var mouse_over := false

func _on_mouse_exited():
	mouse_over = false

func _on_mouse_entered():
	mouse_over = true

func _input(event):
	if(event is InputEventMouse):
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			if(mouse_over):
				selected = true
				
			else:
				selected = false;
