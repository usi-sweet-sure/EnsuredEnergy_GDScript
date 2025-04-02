shader_type canvas_item;

uniform float delta_x: hint_range(-1920, 1920, 10) = 0.0;

void vertex() {
	vec2 delta_vec = vec2(delta_x, 0.0);

	vec2 new_vertex = VERTEX + delta_vec;
	VERTEX = new_vertex;
}