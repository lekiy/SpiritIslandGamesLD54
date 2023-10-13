shader_type canvas_item;

uniform sampler2D noise1 : repeat_enable;
uniform sampler2D noise2 : repeat_enable;
uniform sampler2D mask;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform vec2 scroll1 = vec2(-0.01, 0.01);
uniform vec2 scroll2 = vec2(0.01, -0.01);
uniform float distortion_strength : hint_range(-1, 1) = 0.1;
uniform vec4 top_color : source_color;

void fragment() {
	vec4 texture_col = texture(noise1, UV+scroll1*TIME) * texture(noise2, UV+scroll2*TIME);
	float depth = texture_col.r;
	vec4 screen_col = texture(SCREEN_TEXTURE, SCREEN_UV + distortion_strength * vec2(depth));
	vec4 mask_col = texture(mask, UV);
	COLOR = texture_col*(screen_col*top_color)*mask_col;
}
