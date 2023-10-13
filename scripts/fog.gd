extends Sprite2D


# var shader_clear_texture : Texture2D = material.get_shader_param("clear")

func _input(event):
	if(event.is_action_released("check_state")):
		var image = Image.create(60*20, 60*20, false, Image.Format.FORMAT_RGBA8)
		image.fill_rect(Rect2i(Vector2i(0, 0), Vector2i(60*20, 60*20)), Color.WHITE)

		var circle_center = Vector2(image.get_width()*0.5, image.get_height()*0.5);
		var circle_radius = 8*20;
		for x in circle_radius*2:
			for y in circle_radius*2:
				var start = Vector2(circle_center.x-circle_radius, circle_center.y-circle_radius)
				var pix_position = start+Vector2(x, y)
				var dist = circle_center.distance_to(pix_position)
				var fade_scale = 5
				if(dist <= circle_radius-20):
					image.set_pixelv(pix_position, Color(1, 1, 1, 0))
				else:
					image.set_pixelv(pix_position, Color(1, 1, 1, (dist-(circle_radius-fade_scale))/(fade_scale)))
		material.set("shader_parameter/mask", ImageTexture.create_from_image(image))
		# print(material.get("shader_parameter/mask"))
		# self.texture = ImageTexture.create_from_image(image)
