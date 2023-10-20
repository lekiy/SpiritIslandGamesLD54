shader_type canvas_item;

uniform vec4 flash_color : source_color;

void fragment() {
	vec4 texture_col = texture(TEXTURE, UV);
	COLOR = (flash_color*texture_col.a);
}
