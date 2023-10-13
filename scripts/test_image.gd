extends Sprite2D




# Called when the node enters the scene tree for the first time.
func _ready():
	var image = Image.create(100, 100, false, Image.Format.FORMAT_RGBA8)
	image.fill_rect(Rect2i(Vector2i(0, 0), Vector2i(100, 100)), Color.WHITE)

	var circle_center = Vector2(50, 50);
	var circle_radius = 10;
	for x in image.get_width():
		for y in image.get_height():
			if(circle_center.distance_to(Vector2(x, y)) <= circle_radius):
				image.set_pixel(x, y, Color(0, 0, 0, 0))
			
	self.texture = ImageTexture.create_from_image(image)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
