shader_type canvas_item;

uniform vec4 flash_color : source_color;
uniform bool enabled;

void fragment() {
	vec4 texture_color = texture(TEXTURE, UV);
	if(enabled){
		COLOR = (flash_color*texture_color.a);
	}else{
		COLOR = texture_color;
	}
}
