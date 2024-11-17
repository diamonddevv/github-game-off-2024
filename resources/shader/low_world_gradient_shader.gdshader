shader_type canvas_item;


void fragment() {
	COLOR = vec4(0, 0, 0, (UV.y * 2.) - 0.75);
}
