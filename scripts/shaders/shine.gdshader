shader_type canvas_item;

uniform sampler2D shine_texture;
uniform float time;
uniform float speed;
uniform vec4 tint_color : source_color;

void fragment() {
	vec2 position = (UV-0.5)+time*speed;
	vec4 texture_color = texture(TEXTURE, UV);
	vec4 shine_color = texture(shine_texture, position)*texture_color.a;
	COLOR = texture_color+shine_color.a*tint_color;
}
