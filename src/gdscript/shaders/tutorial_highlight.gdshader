shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform float left: hint_range(0.0, 1.0, 0.0001) = 0.25;
uniform float top: hint_range(0.0, 1.0, 0.0001)= 0.25;
uniform float right: hint_range(0.0, 1.0, 0.0001) = 0.75;
uniform float bottom: hint_range(0.0, 1.0, 0.0001) = 0.75;
uniform float height: hint_range(0.0, 10.0, 0.1) = 3.0;
uniform float frequency: hint_range(0.0, 100.0, 1.0) = 20.0;
uniform float speed: hint_range(0.0, 10.0, 0.1) = 3.0;

void vertex() {
	VERTEX.y += height * sin((frequency * UV.x) + (speed * TIME));
}

void fragment() {
	if (UV.x >= left && UV.y >= top && UV.x <= right && UV.y <= bottom) {
		COLOR.a = 0.0;
	}
}