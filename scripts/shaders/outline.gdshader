shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform float outline_width;

void fragment() {
	vec2 uv = UV;
	vec4 texture_color = texture(TEXTURE, uv);
	vec4 final_color = texture_color;
	if(texture_color.a == 0.0){
		vec2 left = vec2(uv.x+(outline_width*TEXTURE_PIXEL_SIZE.x), uv.y);
		vec2 right = vec2(uv.x-(outline_width*TEXTURE_PIXEL_SIZE.x), uv.y);
		vec2 up = vec2(uv.x, uv.y+(outline_width*TEXTURE_PIXEL_SIZE.y));
		vec2 down = vec2(uv.x, uv.y-(outline_width*TEXTURE_PIXEL_SIZE.y));
		if(texture(TEXTURE, left).a > 0.0){
			final_color = outline_color;
		}
		if(texture(TEXTURE, right).a > 0.0){
			final_color = outline_color;
		}
		if(texture(TEXTURE, up).a > 0.0){
			final_color = outline_color;
		}
		if(texture(TEXTURE, down).a > 0.0){
			final_color = outline_color;
		}
	}
	COLOR = final_color;
}
