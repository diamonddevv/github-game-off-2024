shader_type canvas_item;

uniform bool enabled = false;
uniform float rotate_speed : hint_range(0, 2, 0.1) = 2;
uniform vec4 region;

vec2 rotate(vec2 uv, vec2 pivot, float angle)
{
	mat2 rotation = mat2(vec2(sin(angle), -cos(angle)),
						vec2(cos(angle), sin(angle)));

	uv -= pivot;
	uv = uv * rotation;
	uv += pivot;
	return uv;
}

void fragment() {
	if (enabled) {

		vec3 tint = vec3(rotate(UV, vec2(0.5), TIME * rotate_speed), UV.y);
		COLOR = texture(TEXTURE, UV) * vec4(tint, 1);

	}
}
