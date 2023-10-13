extends Sprite2D


# var shader_clear_texture : Texture2D = material.get_shader_param("clear")

func _ready():
	var image = Image.create(60*20, 60*20, false, Image.Format.FORMAT_RGBA8)
	image.fill_rect(Rect2i(Vector2i(0, 0), Vector2i(60*20, 60*20)), Color.WHITE)

	var circle_center = Vector2(image.get_width()*0.5, image.get_height()*0.5);
	var circle_radius = 3*20;
	for x in image.get_width():
		for y in image.get_height():
			var dist = circle_center.distance_to(Vector2(x, y))
			var fade_scale = 5
			if(dist <= circle_radius-20):
				image.set_pixel(x, y, Color(1, 1, 1, 0))
			else:
				image.set_pixel(x, y, Color(1, 1, 1, (dist-(circle_radius-fade_scale))/(fade_scale)))
	material.set("shader_parameter/mask", ImageTexture.create_from_image(image))
	print(material.get("shader_parameter/mask"))
	# self.texture = ImageTexture.create_from_image(image)
