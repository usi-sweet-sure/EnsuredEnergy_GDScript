shader_type canvas_item;

uniform float left: hint_range(0.0, 1.0, 0.0001) = 0.25;
uniform float top: hint_range(0.0, 1.0, 0.0001)= 0.25;
uniform float right: hint_range(0.0, 1.0, 0.0001) = 0.75;
uniform float bottom: hint_range(0.0, 1.0, 0.0001) = 0.75;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (UV.x >= left && UV.y >= top && UV.x <= right && UV.y <= bottom) {
		COLOR.a = 0.0;
	}

}