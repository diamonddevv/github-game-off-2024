shader_type canvas_item;

uniform float cracking: hint_range(0.0, 1.0, 0.1);
uniform sampler2D noise: repeat_disable;

float dist_from_center(vec2 position)
{
	return length(vec2(0.5) - position);
}

void fragment() {
	vec4 col = texture(TEXTURE, UV);
	float sample = texture(noise, UV * 0.2).r;
	COLOR = col;
	
	if (sample > 0.4 && sample < 0.5 && col.a == 1.0 && dist_from_center(UV) > (1.0 - cracking)) {
		COLOR += vec4(COLOR.rgb / 2.0, 0);
	}
}