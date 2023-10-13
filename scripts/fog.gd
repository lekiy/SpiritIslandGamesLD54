extends Sprite2D


# var shader_clear_texture : Texture2D = material.get_shader_param("clear")

func _ready():
	var image = Image.create(60*20, 60*20, false, Image.Format.FORMAT_RGBA8)
	image.fill_rect(Rect2i(Vector2i(0, 0), Vector2i(100, 100)), Color.WHITE)

	var circle_center = Vector2(50, 50);
	var circle_radius = 10*20;
	for x in image.get_width():
		for y in image.get_height():
			if(circle_center.distance_to(Vector2(x, y)) <= circle_radius):
				image.set_pixel(x, y, Color(0, 0, 0, 0))
	# material.set("shader_parameter/mask", image)
	# self.texture = ImageTexture.create_from_image(image)
