shader_type canvas_item;

// Parameters for the outline when in focus
uniform bool show_outline = false;
uniform vec4 line_color = vec4(1);
uniform float line_thickness = 1.0;
uniform float frequency = 10.0;
uniform float phase_speed = 1.0;

// Parameters for the effect when building the powerplant
uniform bool appear = false;
uniform float percentage: hint_range(0.0, 1.0, 0.01) = 0.0;
uniform float line_angle: hint_range(0.0, 6.28318530718, 0.1308996939) = 3.1;
uniform float line_width: hint_range(0.0, 1.0, 0.01) = 0.02;
uniform vec4 line_color_2: source_color = vec4(1.0);

vec2 rotate(vec2 _pos, float _sine, float _cosine) {
	return vec2(_pos.x * _cosine + _pos.y * -_sine, _pos.x * _sine + _pos.y * _cosine);
}

void fragment() {
	if(show_outline) {
		vec2 size = TEXTURE_PIXEL_SIZE * line_thickness;

		float outline = texture(TEXTURE, UV + vec2(-size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, 0)).a;
		outline += texture(TEXTURE, UV + vec2(0, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, size.y * 0.5)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, size.y * 0.5)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(-size.x, -size.y * 0.5)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, -size.y)).a;
		outline += texture(TEXTURE, UV + vec2(size.x, -size.y * 0.5)).a;
		outline = round(min(outline, 1.0));
		float mul = round(texture(TEXTURE, UV).a);
		if (mul > 0.5) {
			COLOR = texture(TEXTURE, UV);
		}else if (outline > 0.5) {
			vec2 pos = UV - vec2(0.5);
			float angle = atan(pos.y, pos.x);
			if (angle < 0.0) {
				angle += 2.0 * PI;
			}
			float ring = step(0.0, sin(frequency * angle + TIME * phase_speed));
			COLOR = vec4(line_color_2.rgb, ring * line_color.a);
		}
	}

	if(appear) {
		float sine = sin(line_angle);
		float cosine = cos(line_angle);
		float len = abs(sine) + abs(cosine);
		float dist = (rotate(((UV) - vec2(0.5)) / len, sine, cosine).y + 0.5) * (1.0 - line_width);
		float line = step(percentage, dist);
		COLOR.a -= line;
		COLOR.rgb = mix(COLOR.rgb, line_color.rgb, step(percentage, dist + line_width));
	}
}